// ignore_for_file: use_super_parameters, sized_box_for_whitespace, deprecated_member_use, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// --- Constants (Consider moving these to a shared file) ---
const Color primaryBgColor = Color(0xff092531);
const Color textColor = Colors.white;
const Color textColorSecondary = Color.fromARGB(255, 163, 171, 172);
const Color searchBarBgColor = Colors.white;
const Color searchIconColor = Colors.grey;
const double defaultPadding = 16.0;
const double smallPadding = 8.0;
const double avatarRadius = 29.0;


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function()? onViewToggle;
  final Function()? onFilterTap;
  final bool isGridView;

  const CustomAppBar({
    Key? key,
    this.onViewToggle,
    this.onFilterTap,
    this.isGridView = false,
  }) : super(key: key);

  // --- Preferred Size ---
  // Adjusted multiplier slightly, can be tweaked further if needed
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2.6); // Approx 145.6

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Removed screenHeight dependency for layout

    return AppBar(
      surfaceTintColor: Colors.transparent, // Modern way to handle tint
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: primaryBgColor,
      automaticallyImplyLeading: false,
      titleSpacing: 0, // Remove default title spacing
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: defaultPadding, left: defaultPadding, top: defaultPadding*0.3), // Consistent padding
          child: Column(
            // Use spaceBetween to push search bar towards bottom
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- Top Row: User Info & Actions ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center, // Center items vertically
                children: [
                  // --- User Info ---
                  Row(
                    children: [
                      // Use Padding for avatar spacing
                      Padding(
                        padding: const EdgeInsets.only(right: smallPadding),
                        child: CircleAvatar(
                          radius: avatarRadius,
                          // Consider adding errorBuilder for image loading
                          backgroundImage: const AssetImage("assets/images/avatar.jpg"),
                           backgroundColor: Colors.grey[300], // Placeholder color
                        ),
                      ),
                      // Removed the fixed-height Container and simplified nested Columns
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                        children: [
                          const Text(
                            'Hi, User', // Consider making this dynamic
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontFamily: 'Satoshi-Bold', // Ensure font is included
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                           const SizedBox(height: 2), // Small gap
                          const Text(
                            'user@gmail.com', // Consider making this dynamic
                            style: TextStyle(
                              color: textColorSecondary,
                              fontSize: 12,
                              fontFamily: 'Satoshi-Regular', // Ensure font is included
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // --- Action Icons ---
                  Row(
                    mainAxisSize: MainAxisSize.min, // Prevent Row from taking extra space
                    children: [
                      // Grid/List view toggle
                      IconButton(
                                icon: isGridView? ImageIcon(AssetImage('assets/Icons/list1.png'),
                              color: Color(0xffffffff),
                              size: 20,): Icon(CupertinoIcons.circle_grid_3x3,color: Colors.white,size: 20,),
                                onPressed: onViewToggle,
                              ),
                      // Filter Icon
                      IconButton(
                        // Consider using a standard filter icon if asset is problematic
                        icon: const ImageIcon(AssetImage('assets/Icons/filter_alt1.png'),color: Colors.white,),
                        onPressed: onFilterTap,
                        tooltip: 'Filter Books',
                      ),
                    ],
                  ),
                ],
              ),

              // --- Search Bar ---
              // Use Padding for spacing instead of relying on spaceAround
              Padding(
                padding: const EdgeInsets.only(bottom: smallPadding), // Add padding below search bar
                child: SizedBox( // Constrain the SearchBar height
                  height: 35,
                  width: screenWidth*0.8,
                  child: SearchBar(
                    backgroundColor: MaterialStateProperty.all<Color>(searchBarBgColor),
                    elevation: MaterialStateProperty.all<double>(1.0), // Add subtle elevation
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>( // Adjust internal padding
                       const EdgeInsets.symmetric(horizontal: smallPadding),
                    ),
                    leading: const Padding( // Add padding to leading icon
                       padding: EdgeInsets.only(left: smallPadding),
                       child: ImageIcon(
                         AssetImage('assets/Icons/Search_alt.png'),
                         color: searchIconColor,
                         size: 22, // Adjust icon size
                       ),
                    ),
                      hintText: 'Search library...',
                      hintStyle: WidgetStatePropertyAll(TextStyle(fontFamily: 'Satoshi-Bold',color: Color(0xffB0AFAF))),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
