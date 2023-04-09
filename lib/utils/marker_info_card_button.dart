import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';


class MarkerInfoCardButton extends StatelessWidget {
  final tituloConFecha;
  final detalleEvento;
  final eventoUrl;
  final imageUrl;

  const MarkerInfoCardButton({
    required this.tituloConFecha,
    required this.detalleEvento,
    required this.eventoUrl,
    required this.imageUrl,
  });

  Future<void> launchUrl(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launchUrl(Uri.parse(url.toString()));
      //await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tituloConFecha,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            CachedNetworkImage(

              imageUrl: imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 150,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(detalleEvento, textAlign: TextAlign.justify),
            ),
            //const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // ignore: deprecated_member_use
                if (await canLaunch(eventoUrl)) {
                  await launchUrl(Uri.parse(eventoUrl));
                } else {
                  throw 'Could not launch $eventoUrl';
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  eventoUrl,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
