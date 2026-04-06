import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_guard/core/consts/app_theme.dart';
import 'package:green_guard/core/di/di_container.dart';
import 'package:green_guard/presentation/home/bloc/home_bloc.dart';
import 'package:green_guard/presentation/home/bloc/home_event.dart';
import 'package:green_guard/presentation/home/bloc/home_state.dart';
import 'package:green_guard/presentation/home/widgets/category_chip.dart';
import 'package:green_guard/presentation/home/widgets/plant_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _categories = [
    ('All', '🌱'),
    ('Indoor Plant', '🌿'),
    ('Tropical', '🌴'),
    ('Flowering', '🌸'),
    ('Outdoor Plant', '🌵'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(HomePlantsRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  //SliverToBoxAdapter(child: _buildHeader(context)),
                  SliverToBoxAdapter(child: _buildSearch()),
                  SliverToBoxAdapter(child: _buildCategories()),
                  _buildPlantList(),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeader(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 44,
  //           height: 44,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             gradient: const LinearGradient(
  //               colors: [Color(0xFFC8E6C9), Color(0xFF81C784)],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //             border: Border.all(color: Colors.white, width: 2),
  //           ),
  //           child: const Center(
  //             child: Text('A',
  //                 style: TextStyle(
  //                   fontSize: 17,
  //                   fontWeight: FontWeight.w800,
  //                   color: Color(0xFF2E7D32),
  //                 )),
  //           ),
  //         ),
  //         const SizedBox(width: 10),
  //         Expanded(
  //           child: BlocBuilder<AuthBloc, AuthState>(
  //             builder: (context, state) {
  //               final name = state is AuthAuthenticated ? state.user.name : 'Alex';
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('Hi, $name',
  //                       style: const TextStyle(
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w700,
  //                           color: AppTheme.textDark)),
  //                   const Text('Welcome back',
  //                       style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //         _circleButton(
  //           onTap: () => context.read<AuthBloc>().add(AuthSignOutRequested()),
  //           child: const Icon(Icons.notifications_outlined,
  //               size: 20, color: AppTheme.textDark),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Plants',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 16),
                      Icon(Icons.search, color: AppTheme.textMuted, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Search Plants',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _circleButton(
                size: 50,
                radius: 14,
                child: const Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required Widget child,
    VoidCallback? onTap,
    double size = 44,
    double radius = 50,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildCategories() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final selected = state is HomeLoaded ? state.selectedCategory : 'All';
        return SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            itemCount: HomePage._categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final (label, emoji) = HomePage._categories[i];
              return CategoryChipWidget(
                label: label,
                emoji: emoji,
                isSelected: selected == label,
                onTap: () => context.read<HomeBloc>().add(
                  HomePlantsRequested(category: label == 'All' ? null : label),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPlantList() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              ),
            ),
          );
        }
        if (state is HomeError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppTheme.textMuted),
                ),
              ),
            ),
          );
        }
        if (state is HomeLoaded) {
          if (state.plants.isEmpty) {
            return const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Center(
                  child: Text(
                    'No plants found 🌵',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
                  ),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              final plant = state.plants[i];
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: PlantCardWidget(plant: plant, isGreen: i % 2 == 1),
              );
            }, childCount: state.plants.length),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
