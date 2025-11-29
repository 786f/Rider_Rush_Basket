import 'package:flutter/material.dart';
import 'package:riderrushbasketapp/app/module/auth/workdetail/citypage/screen/selectstorepage.dart';

class CityConfirmPage extends StatelessWidget {
  final String city;

  CityConfirmPage({required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFF7EF),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Confirm City",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFFF28C28),
            fontSize: 20,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Icon(Icons.help_outline, color: Colors.black),
                SizedBox(width: 4),
                Text(
                  "Help",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Column(
        children: [

          const SizedBox(height: 40),

          // 📍 Location Icon inside a card
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on_rounded,
              size: 80,
              color: Color(0xFFF28C28),
            ),
          ),

          SizedBox(height: 30),

          Text(
            "We've detected your city",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 10),

          Text(
            city,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 12),

          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              "Change City",
              style: TextStyle(
                color: Color(0xFFF28C28),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          Spacer(),

          // Continue button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF28C28),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelectStorePage(),
                    ),
                  );
                },
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
