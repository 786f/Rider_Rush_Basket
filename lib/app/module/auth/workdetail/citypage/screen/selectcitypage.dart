import 'package:flutter/material.dart';
import 'cityconfirmpage.dart';

class SelectCityPage extends StatefulWidget {
  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  String? selectedCity;
  String searchText = "";

  List<String> cities = [
    "Agra","Ahmedabad","Ajmer","Aligarh","Allahabad","Amritsar","Aurangabad",
    "Bangalore","Bareilly","Belgaum","Bhavnagar","Bhopal","Bhubaneswar","Bikaner",
    "Chandigarh","Chennai","Coimbatore","Cuttack",
    "Dehradun","Delhi","Dhanbad","Durgapur",
    "Faridabad","Firozabad",
    "Ghaziabad","Gorakhpur","Guntur","Gurgaon","Guwahati","Gwalior",
    "Hyderabad",
    "Indore","Itanagar",
    "Jaipur","Jalandhar","Jammu","Jamshedpur","Jhansi","Jodhpur",
    "Kanpur","Kochi","Kolkata","Kollam","Kota","Kozhikode",
    "Lucknow","Ludhiana",
    "Madurai","Mangalore","Meerut","Moradabad","Mumbai","Mysore",
    "Nagpur","Nashik","Noida",
    "Patna","Pondicherry","Prayagraj","Pune",
    "Raipur","Rajkot","Ranchi","Rourkela",
    "Salem","Saharanpur","Shimla","Siliguri","Surat",
    "Thane","Thiruvananthapuram","Thrissur","Tiruchirappalli","Tirunelveli","Tirupati",
    "Udaipur","Ujjain",
    "Varanasi","Vijayawada","Visakhapatnam",
  ];

  @override
  Widget build(BuildContext context) {
    List<String> filteredCities = cities
        .where((city) =>
        city.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFFFFF3E5),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFF3E5),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Select City",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800,
            color: Color(0xFFF28C28),
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
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

          // 🔍 Search TextField
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child:

            Column(
              children: [
                Text(
                  'Please select the city where you want to work',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  onChanged: (value) {
                    setState(() => searchText = value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search your city",
                    hintStyle: TextStyle( fontWeight: FontWeight.w400,color: Colors.black45,),
                    prefixIcon: Icon(Icons.search, color: Color(0xFFF28C28)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.orange.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Color(0xFFF28C28), width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---- City List ----
          Expanded(
            child: filteredCities.isEmpty
                ? Center(
              child: Text(
                "No cities found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredCities[index]),
                  trailing: Radio(
                    value: filteredCities[index],
                    groupValue: selectedCity,
                    activeColor: Color(0xFFF28C28),
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value.toString();
                      });
                    },
                  ),
                  onTap: () {
                    setState(() => selectedCity = filteredCities[index]);
                  },
                );
              },
            ),
          ),

          // ---- Continue Button ----
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: GestureDetector(
              onTap: () {
                if (selectedCity == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a city"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CityConfirmPage(city: selectedCity!),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF28C28),
                      Color(0xFFE37814),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
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
