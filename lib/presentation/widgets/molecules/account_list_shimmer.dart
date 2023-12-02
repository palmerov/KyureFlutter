//shimmer for account list
import 'package:flutter/material.dart';
import 'package:kyure/presentation/theme/ky_theme.dart';
import 'package:shimmer/shimmer.dart';

class AccountListShimmerMolecule extends StatelessWidget {
  const AccountListShimmerMolecule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kyTheme = KyTheme.of(context)!;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: kyTheme.colorSeparatorLine,
          highlightColor: kyTheme.colorBackground,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          width: 80,
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 14,
                          width: 130,
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
