




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  late String inputStr;
  final controller  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Input a number"),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_){
            addConcrete();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                  onPressed:addConcrete ,
                  child: Text('Search'),
                  style: ButtonStyle(),
                )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
                  onPressed: addRandom,
                  child: Text('Get random trivia'),
                  style: ButtonStyle(),
                ))
          ],
        )
      ],
    );
  }

  void addConcrete(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumberEvent(inputStr));
  }

  void addRandom(){
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumberEvent());
  }
}
