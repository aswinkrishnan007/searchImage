import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchimage/model/search_model.dart';
import 'package:searchimage/service/service_locator.dart';
import 'package:searchimage/utils/constants.dart';
import 'package:searchimage/view/listing_view.dart';
import 'package:searchimage/viewmodel/myhome_viewmodel.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final TextEditingController _controller = TextEditingController();
  ScrollController controller = ScrollController();
  void scrollListener() async {
    print("lazyloading....");
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      int count = _viewModel.lazyloading.length;
      int hitcount = _viewModel.hits.length;
      if (count + 4 > hitcount) {
        setState(() {
          _viewModel.lazyloading = _viewModel.hits;
        });
      } else {
        setState(() {
          List<Hits> temp = _viewModel.hits.sublist(count, count + 5);
          _viewModel.lazyloading.addAll(temp);
        });
      }
    }
  }

  final MyHomeViewModel _viewModel = serviceLocator<MyHomeViewModel>();
  @override
  void initState() {
    _viewModel.getSearch(context, "");
    controller.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => _viewModel,
          child: Consumer<MyHomeViewModel>(builder: (context, model, child) {
            return Scaffold(
              backgroundColor: Colorconstants.colorF1EFFF,
              body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchArea(context, model),
                    const SizedBox(height: 25),
                    _viewModel.loader
                        ? const Center(child: CircularProgressIndicator())
                        : _viewModel.lazyloading.isEmpty
                            ? noDataFound()
                            : ListingView(
                                controller: controller, viewModel: _viewModel)
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  SizedBox noDataFound() {
    return SizedBox(
      child: Center(
        child: Text(
          "no data found !!",
          style: TextStyle(
            color: Colorconstants.color1A059D,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 15,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Container searchArea(BuildContext context, MyHomeViewModel model) {
    return Container(
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colorconstants.color9745FF.withOpacity(.6),
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0)),
      ),
      child: Container(
          margin:
              const EdgeInsets.only(left: 15, right: 15, bottom: 25, top: 20),
          padding: const EdgeInsets.only(left: 0),
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colorconstants.color1A059D.withOpacity(.52), width: 1),
            color: Colorconstants.colorFFFFFF,
          ),
          child: TextFormField(
            controller: _controller,
            onTap: () {},
            autofocus: false,
            cursorColor: Colorconstants.color1A059D,
            style: TextStyle(
              color: Colorconstants.color1A059D,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 15,
              letterSpacing: 1,
            ),
            decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colorconstants.color1A059D,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colorconstants.color1A059D,
                    size: 15,
                  ),
                  onPressed: () {
                    _controller.clear();
                    _viewModel.getSearch(context, _controller.text);
                  },
                ),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colorconstants.color1A059D,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
                border: InputBorder.none),
            onChanged: (value) {
              _viewModel.getSearch(context, _controller.text);
            },
          )),
    );
  }
}
