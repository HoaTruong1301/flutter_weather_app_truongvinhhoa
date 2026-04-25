import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Weather App")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Nhập thành phố",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    provider.getWeather(controller.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                provider.getWeather(controller.text);
              },
              child: Text("Xem thời tiết"),
            ),
            SizedBox(height: 30),
            if (provider.isLoading)
              CircularProgressIndicator()
            else if (provider.weather != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(provider.weather!.city,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("${provider.weather!.temp}°C",
                        style: TextStyle(fontSize: 50, color: Colors.blue)),
                    Text(provider.weather!.description,
                        style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                  ],
                ),
              )
            else
              Text("Nhập tên thành phố để xem thời tiết"),
          ],
        ),
      ),
    );
  }
}