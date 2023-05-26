import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivianumbers/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:trivianumbers/injection_container.dart';
import 'package:trivianumbers/features/number_trivia/presentation/widget/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Number Trivia'),
        ),
        body: SingleChildScrollView(child: buildBody()));
  }
}

class buildBody extends StatelessWidget {
  const buildBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              //Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start Searching',
                    );
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return  TriviaDisplay(numberTrivia: state.trivia);
                  }

                  return Placeholder();
                },
              ),

              SizedBox(height: 20),
              //Bottom half
              TriviaControl()
            ],
          ),
        ),
      ),
    );
  }
}
