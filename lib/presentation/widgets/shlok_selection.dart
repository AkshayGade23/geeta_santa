import 'package:flutter/material.dart';
import 'package:geeta_santha/core/constants/colors.dart';
import 'package:geeta_santha/core/utils/calculate_width_height.dart';


class ShlokSelection extends StatefulWidget {
  final PageController pageController;
  final numberOfShloks;

  const ShlokSelection({
    Key? key,
    required this.pageController,
    required this.numberOfShloks,
  }) : super(key: key);

  @override
  _ShlokSelectionState createState() => _ShlokSelectionState();
}

class _ShlokSelectionState extends State<ShlokSelection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int selectedItem = -1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.reverse();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Center(
        child: Container(
          width: size.width * 0.9,
          height: size.height * 0.65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding:  EdgeInsets.symmetric(vertical: scaleHeight(context,20)),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5F2EEA), Color(0xFF3A86FF)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Jump to Shlok",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Grid of shloks
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: scaleWidth(context,12)),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: scaleHeight(context, 5),
                      crossAxisSpacing: scaleWidth(context, 8),
                      childAspectRatio: 1.2,
                    ),
                    itemCount: widget.numberOfShloks,
                    itemBuilder: (context, index) {
                  
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItem = index;
                          });
                        },
                        child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                      
                          color: selectedItem == index
                              ? primaryPurple
                              : primaryBlue,
                        ),
                        margin:  EdgeInsets.symmetric(horizontal: scaleWidth(context, 6), vertical: scaleHeight(context, 6)),
                        alignment: Alignment.center,
                      
                        child: Text(
                          "${index+1}",
                          textAlign: TextAlign.center,
                          style:  TextStyle(
                            fontSize: scaleFont(context,12),
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      );
                    },
                  ),
                ),
              ),

              // OK button
              Padding(
                padding:  EdgeInsets.symmetric(vertical: scaleHeight(context, 12)),
                child: GestureDetector(
                  onTap: () {
                    if (selectedItem != -1) {
                      widget.pageController.jumpToPage(selectedItem);
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: scaleWidth(context, 40), vertical: scaleHeight(context, 14)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5F2EEA), Color(0xFF3A86FF)],
                      ),
                    ),
                    child:  Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: scaleFont(context,16),
                      ),
                    ),
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
