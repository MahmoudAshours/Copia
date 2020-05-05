import 'package:copia/Moor/table.dart';
import 'package:copia/Provider/uppdf_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Providers extends StatelessWidget {
  final Widget child;
  Providers({@required this.child});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UploadPdfBloc()),
        Provider(create: (_) => AppDatabase())
      ],
      child: child,
    );
  }
}
