import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/view_models/home_viewmodel.dart';
import 'package:extended_image/extended_image.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final city = ref.watch(ciryStateProvider);
    final cityNotifier = ref.read(ciryStateProvider.notifier);
    final weather = ref.watch(weatherStateProvider);
    final isLoading = ref.watch(isLoadingProvider);

    const border = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.white,
    ));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title:  SizedBox(
          height: 40,
          child: TextField(
            controller: cityNotifier.cityController,
            decoration:const InputDecoration(
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: border,
              focusedBorder: border,
              hintText: "Search US cities",
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: cityNotifier.getCity,
            child: const Text(
              "Find",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: Builder(builder: (context) {
        if(isLoading){

          return const Center(child: CircularProgressIndicator(),);
        }
        if (weather == null || city == null) {
          return const Center(
            child: Text("Search weather..."),
          );
        }

        final date = DateTime.fromMillisecondsSinceEpoch(weather.dt * 1000);
        final formattedDate = DateFormat("EEEE, MMMM d'", "en_US").format(date);
        return Center(
          child: Column(
            children: [
              const Spacer(),
              ExtendedImage.network(
                weather.weatherIconUrl,
              ),
              const SizedBox(height: 20),
              Text(weather.description),
              const SizedBox(height: 10),
              Text(
                "${city.name}, ${city.state}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(formattedDate),
              const SizedBox(height: 10),
              Text(
                "${weather.temp.round()}%",
                style: TextStyle(fontSize: 80, fontWeight: FontWeight.w100),
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
            ],
          ),
        );
      }),
    );
  }
}
