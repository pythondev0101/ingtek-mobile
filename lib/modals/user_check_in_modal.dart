import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:ingtek_mobile/components/expanded_button.dart';
import 'package:ingtek_mobile/global_variables.dart';
import 'package:ingtek_mobile/models/event_model.dart';
import 'package:ingtek_mobile/models/user_model.dart';
import 'package:ingtek_mobile/utilities/color_utility.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class UserCheckinInModal extends StatefulWidget {
  final User user;
  final Event? event;

  UserCheckinInModal({Key? key, required this.user, this.event}) : super(key: key);

  @override
  _UserCheckinInModalState createState() => _UserCheckinInModalState();
}

class _UserCheckinInModalState extends State<UserCheckinInModal> {
  bool _isLoading = false;
  final mongo.DbCollection eventCollection = globalMongoDB!.collection('events');

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      scrollable: true,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("${widget.user.fname!} ${widget.user.mname!} ${widget.user.lname!}",
                 style: const TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 20
              ),),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ))
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text("TFOE No.: ${widget.user.tfoeNo!}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text("Batch: ${widget.user.batch!}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: _isLoading == false
                ? ExpandedButton(
                    buttonColor: AppColors.secondary,
                    borderRadius: 20,
                    expanded: true,
                    elevation: 1,
                    title: 'Check-in',
                    titleFontSize: 14,
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      eventCollection.updateOne({'_id': widget.event!.mongoId}, {"\$push": {'attendances': widget.user.mongoId}}).then(
                        (value){
                        Navigator.pop(context);

                        Toast.show("Check in Successfully!");
                        setState(() {
                          _isLoading = false;
                        });
                      }).catchError((err){
                      setState(() {
                        _isLoading = false;
                      });
                      });
                    },
                    titleAlignment: Alignment.center,
                    titleColor: Colors.white,
                  )
                : const CircularProgressIndicator(),
          ),
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
