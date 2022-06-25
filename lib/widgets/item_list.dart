import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_travel_mobile/models/checklist.dart';
import 'package:pocket_travel_mobile/providers/checklist_provider.dart';
import 'package:pocket_travel_mobile/services/checklist_service.dart';
import 'package:provider/provider.dart';

class ItemList extends StatelessWidget {
  ItemList({Key? key}) : super(key: key);

  final Map<String, dynamic> _checklistData = {
    "name": "",
  };

  @override
  Widget build(BuildContext context) {
    List<Checklist> checklist = context.watch<ChecklistProvider>().getChecklist;
    return Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: checklist.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          onChanged: (text) {
                            _checklistData['name'] = text;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Add new items',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await ChecklistService(context)
                            .createChecklist(_checklistData);
                        await ChecklistService(context).getAllChecklist();
                      },
                      child: Container(
                        color: const Color(0xff5a67d8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: const Text(
                          'Add',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }

            final check = checklist[index - 1];
            return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              check.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onTap: () async {
                                await ChecklistService(context)
                                    .deleteChecklist(check.item_id);
                                await ChecklistService(context)
                                    .getAllChecklist();
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ));
  }
}
