import 'package:deleveus_app/app/app.dart';
import 'package:deleveus_app/delivery/delivery.dart';
import 'package:deleveus_app/home/home.dart';
import 'package:deleveus_app/l10n/l10n.dart';
import 'package:deleveus_app/order/order.dart';
import 'package:deleveus_app/profile/profile.dart';
import 'package:deleveus_app/search/search.dart';
import 'package:deleveus_app/settings/settings.dart';
import 'package:deleveus_app/utils/utils.dart';
import 'package:deleveus_app/widgets/widgets.dart';
import 'package:delivery_repository/delivery_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  static Page<void> page() => MaterialPage<void>(child: HomePage());
  final _foodRepository = FoodRepository();
  final _orderRepository = OrderRepository();
  // final _deliveryRepository = DeliveryRepository();

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    final orderBloc = OrderBloc(_orderRepository, user);
    // final deliveryBloc = DeliveryBloc(_deliveryRepository);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _foodRepository),
        RepositoryProvider.value(value: _orderRepository),
        // RepositoryProvider.value(value: _deliveryRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => FoodMenuBloc(_foodRepository),
          ),
          BlocProvider(create: (_) => orderBloc),
          // BlocProvider(create: (_) => deliveryBloc)
        ],
        child: HomeView(orderBloc: orderBloc), //, deliveryBloc: deliveryBloc),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    required this.orderBloc,
    // required this.deliveryBloc,
    super.key,
  });
  final OrderBloc orderBloc;
  // final DeliveryBloc deliveryBloc;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              height: 130,
              padding: const EdgeInsets.only(top: 10),
              color: Theme.of(context).primaryColorLight.withOpacity(0.7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) => state.orderItems.isEmpty
                        ? Container()
                        : Badge(
                            padding: l10n.localeName == 'en'
                                ? const EdgeInsets.all(7)
                                : const EdgeInsets.only(
                                    top: 5,
                                    bottom: 7,
                                    right: 7,
                                    left: 7,
                                  ),
                            largeSize: l10n.localeName == 'en' ? 25 : 20,
                            label: Text('${state.orderItems.length}'),
                            backgroundColor: Colors.red,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<OrderBasketPage>(
                                  builder: (context) => OrderBasketPage(
                                    orderBloc: orderBloc,
                                    appBloc: context.read<AppBloc>(),
                                  ),
                                ),
                              ),
                              icon: Icon(
                                Icons.shopping_cart_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 100,
                    child: Image.asset('assets/imgs/ic_deleveus.png'),
                  ),
                  const Spacer(),
                  PopupMenuButton<MenuOptions>(
                    onSelected: (value) {
                      final route = getRouteForSelectedOption(value, context);
                      Navigator.of(context).push(
                        MaterialPageRoute<Widget>(builder: (_) => route),
                      );
                    },
                    itemBuilder: (ctx) => [
                      _buildPopupMenuItem(
                        l10n.homeSearchOptionText,
                        Icons.search,
                        MenuOptions.search,
                      ),
                      _buildPopupMenuItem(
                        l10n.homeSettingsOptionText,
                        Icons.settings,
                        MenuOptions.settings,
                      ),
                      _buildPopupMenuItem(
                        l10n.homeProfileOptionText,
                        Icons.account_circle,
                        MenuOptions.profile,
                      ),
                      _buildPopupMenuItem(
                        l10n.homeHistoryOptionText,
                        Icons.history,
                        MenuOptions.history,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextButton.icon(
                    label: Text(
                      l10n.homeDeliveryButtonText,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<DeliveryPage>(
                          builder: (context) => DeliveryPage(
                            orderBloc: orderBloc,
                          ), //(deliveryBloc: deliveryBloc),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.motorcycle_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton.icon(
                    style: ButtonStyle(
                      padding:
                          const MaterialStatePropertyAll(EdgeInsets.all(10)),
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).primaryColorLight.withOpacity(0.7),
                      ),
                    ),
                    label: Text(
                      l10n.homeMenuButtonText,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.dining_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              final activeOrder = getActiveOrder(state.prevOrders);
              return activeOrder == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: ActiveOrder(activeOrder, orderBloc),
                    );
            },
          ),
          BlocConsumer<FoodMenuBloc, FoodMenuState>(
            listenWhen: (previous, current) => current.errorMessage.isNotEmpty,
            listener: (context, state) {
              if (state.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                    ),
                  );
                context
                    .read<FoodMenuBloc>()
                    .add(const ClearErrorMessageEvent());
              }
            },
            builder: (context, state) {
              if (state.foods.isEmpty) {
                if (state.status == FoodsListStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 1),
                  );
                } else if (state.status != FoodsListStatus.success) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Text(
                      'No foods exists', //"l10n.foodEmptyListText",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
              }
              return Expanded(
                child: ClipPath(
                  clipper: ContentClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(top: 50),
                    color: Theme.of(context).primaryColorLight.withOpacity(0.7),
                    child: Column(
                      children: [
                        Flexible(
                          child: appFilterChoiceChip(state),
                        ),
                        Flexible(
                          flex: 6,
                          child: appMenuListView(state),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget getRouteForSelectedOption(MenuOptions value, BuildContext context) {
    final widget = switch (value) {
      MenuOptions.profile => const ProfilePage(),
      MenuOptions.settings => const SettingsPage(),
      MenuOptions.search => const SearchPage(),
      MenuOptions.history => BlocProvider<OrderBloc>.value(
          value: context.read<OrderBloc>(),
          child: const HistoryPage(),
        ),
    };
    return widget;
  }

  MasonryGridView appMenuListView(FoodMenuState state) {
    return MasonryGridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: state.foods.length,
      itemBuilder: (context, index) {
        final foodListTile = FoodListTile(
          food: state.foods[index],
          orderBloc: context.read<OrderBloc>(),
        );
        return foodListTile
            .animate()
            .fadeIn(delay: (index * 100).ms)
            .slide(
              begin: const Offset(0.5, 0),
              duration: 200.ms,
              curve: Curves.easeOut,
              delay: (index * 100).ms,
            )
            .shimmer(duration: 400.ms);
      },
    );
  }

  ListView appFilterChoiceChip(FoodMenuState state) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 20 : 8),
          child: ChoiceChip(
            labelPadding: state.categories[index] == state.filter
                ? const EdgeInsets.symmetric(vertical: 5, horizontal: 12)
                : null,
            label: Text(
              state.categories[index].capitalize(),
            ),
            selected: state.categories[index] == state.filter,
            elevation: state.categories[index] == state.filter ? 6 : 3,
            onSelected: (_) {
              context.read<FoodMenuBloc>().add(
                    FetchFoodOrFilterdEvent(
                      state.categories[index],
                    ),
                  );
            },
            selectedColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: state.categories[index] == state.filter
                  ? Colors.white
                  : Colors.black,
            ),
            backgroundColor: Colors.grey[200],
            padding: const EdgeInsets.all(10),
          ),
        )
            .animate()
            .shimmer(duration: (index * 0.2).seconds)
            .then()
            .slideX(duration: 500.ms)
            .then()
            .fadeIn(duration: 500.ms);
      },
    );
  }

  PopupMenuItem<MenuOptions> _buildPopupMenuItem(
    String title,
    IconData iconData,
    MenuOptions position,
  ) {
    return PopupMenuItem<MenuOptions>(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          const SizedBox(width: 6),
          Text(title),
        ],
      ),
    );
  }
}
