
import 'package:get_it/get_it.dart';
import 'package:searchimage/viewmodel/myhome_viewmodel.dart';


GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  //Services should be register as lazy singleton. Services are shared across app

  //Viewmodles should be register as factory. Viewmodel instances are binded to its view.
  
  serviceLocator
      .registerFactory<MyHomeViewModel>(() => MyHomeViewModel());
}
