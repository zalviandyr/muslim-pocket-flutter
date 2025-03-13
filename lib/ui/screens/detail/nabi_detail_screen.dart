import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';

class NabiDetailScreen extends StatefulWidget {
  final Nabi nabi;

  const NabiDetailScreen({required this.nabi});

  @override
  _NabiDetailScreenState createState() => _NabiDetailScreenState();
}

class _NabiDetailScreenState extends State<NabiDetailScreen> {
  late NabiDetailScreenBloc _nabiDetailScreenBloc;

  @override
  void initState() {
    _nabiDetailScreenBloc = BlocProvider.of<NabiDetailScreenBloc>(context);

    // fetch
    _nabiDetailScreenBloc.add(NabiDetailScreenFetch(slug: widget.nabi.slug));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nabi.nabi),
      ),
      body: BlocBuilder<NabiDetailScreenBloc, NabiState>(
        builder: (context, state) {
          if (state is NabiDetailScreenFetchSuccess) {
            NabiDetail nabiDetail = state.nabiDetail;

            return ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: Measure.horizontalPadding,
                  vertical: Measure.verticalPadding),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Measure.borderRadius),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.width * 0.4,
                    imageUrl: nabiDetail.thumb,
                    placeholder: (context, url) {
                      return Center(child: CircularProgressIndicator());
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Tahun kelahiran : ${nabiDetail.bornDate}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Usia : ${nabiDetail.age}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5.0),
                Text(
                  nabiDetail.description,
                  textAlign: TextAlign.justify,
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
