import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'workersList.dart'; // Import the unified WorkerListPage

class CategoryPage extends StatelessWidget {
  final int categoryNumber;

  const CategoryPage({Key? key, required this.categoryNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String categoryName;
    List<Map<String, String>> items;

    switch (categoryNumber) {
      case 1:
        categoryName = 'Electrical';
        items = [
          {
            'name': 'Air Conditioner',
            'image': 'assets/images/airconditioner.jpeg'
          },
          {'name': 'Refrigerator', 'image': 'assets/images/refrigerator.jpg'},
          {'name': 'Dishwasher', 'image': 'assets/images/dishwasher.jpg'},
          {'name': 'Microwave', 'image': 'assets/images/microwave.jpg'},
          {'name': 'Gas Heater', 'image': 'assets/images/gas1.jpg'},
          {
            'name': 'Electric Heater',
            'image': 'assets/images/electricHeater.jpg'
          },
        ];
        break;
      case 2:
        categoryName = 'Mechanical';
        items = [
          {'name': 'Motor', 'image': 'assets/images/carmotor.jpg'},
          {'name': 'Battery', 'image': 'assets/images/battery.jpg'},
          {
            'name': 'Electro Mechanics',
            'image': 'assets/images/electromechanics.jpg'
          },
          {'name': 'Chassis', 'image': 'assets/images/chassis.jpg'},
          {'name': 'Clutch', 'image': 'assets/images/clutch.jpg'},
          {'name': 'Gearbox', 'image': 'assets/images/gearbox.jpg'},
          {'name': 'Exhaust', 'image': 'assets/images/exhaust.jpg'},
        ];
        break;
      case 3:
      default:
        categoryName = 'Furniture';
        items = [
          {'name': 'Sofa', 'image': 'assets/images/sofa.jpg'},
          {'name': 'Recliner', 'image': 'assets/images/recliner.jpg'},
          {'name': 'Coffee Corner', 'image': 'assets/images/coffeecorner.jpg'},
          {'name': 'Table', 'image': 'assets/images/table.jpg'},
          {'name': 'Door Wardrobe', 'image': 'assets/images/doorwardrobe.jpg'},
          {'name': 'Bed', 'image': 'assets/images/bed.jpg'},
        ];
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                categoryName,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 22),
            // Item Rows
            for (int i = 0; i < items.length; i += 2)
              Column(
                children: [
                  ItemRow(
                    image1: items[i]['image']!,
                    text1: items[i]['name']!,
                    image2:
                        (i + 1 < items.length) ? items[i + 1]['image']! : '',
                    text2: (i + 1 < items.length) ? items[i + 1]['name']! : '',
                    isFullWidth: (i + 1 >= items.length),
                    onTap1: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkerListPage(categoryNumber: categoryNumber),
                        ),
                      );
                    },
                    onTap2: (i + 1 < items.length)
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WorkerListPage(
                                    categoryNumber: categoryNumber),
                              ),
                            );
                          }
                        : null,
                  ),
                  SizedBox(height: 17),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  final String image1;
  final String text1;
  final String image2;
  final String text2;
  final bool isFullWidth;
  final VoidCallback? onTap1;
  final VoidCallback? onTap2;

  const ItemRow({
    required this.image1,
    required this.text1,
    required this.image2,
    required this.text2,
    this.isFullWidth = false,
    this.onTap1,
    this.onTap2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap1,
            child: Container(
              margin: EdgeInsets.only(right: isFullWidth ? 0 : 15),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Column(
                children: [
                  Container(
                    height:
                        150, // Set a consistent height for the image container
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      image: DecorationImage(
                        fit: BoxFit
                            .contain, // Ensures the entire image is visible
                        image: AssetImage(image1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isFullWidth && image2.isNotEmpty && text2.isNotEmpty)
          Expanded(
            child: GestureDetector(
              onTap: onTap2,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(image2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
