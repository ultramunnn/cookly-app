import 'package:cookly_app/widgets/components/custom_linegap.dart';
import 'package:cookly_app/widgets/components/custom_navbar.dart';
import 'package:cookly_app/widgets/components/custom_searchbar.dart';
import 'package:cookly_app/widgets/sections/home/populerrecipe_section.dart';
import 'package:flutter/material.dart';
import 'package:cookly_app/widgets/sections/home/recipetoday_section.dart';
import 'package:cookly_app/widgets/sections/home/categoryfilter_section.dart';
import 'package:cookly_app/widgets/sections/home/desserts_section.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 100,
          ), // biar tidak ketutup navbar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomNavbar(),
              CustomSearchbar(
                hintText: 'Cari Resep',
                onTap: () {},
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              RecipytodaySection(),
              const SizedBox(height: 24),
              LineGap(),
              const SizedBox(height: 24),
              PopulerRecipe(),
              const SizedBox(height: 24),
              LineGap(),
              const SizedBox(height: 24),
              CategoryFilterSection(
                onSelected: (value) {
                  print('Kategori dipilih: $value');
                },
              ),
              const SizedBox(height: 24),
              LineGap(),
              const SizedBox(height: 24),
              DessertsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
