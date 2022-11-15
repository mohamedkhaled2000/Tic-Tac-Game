import 'package:flutter/material.dart';
import 'package:tic_tac_game/pages/game_logic.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String activePlayer = 'x';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    var orintation = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: orintation
              ? Column(
                  children: [
                    ...firstBlock(),
                    _expanded(context),
                    ...lastBlock(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...firstBlock(),
                        const SizedBox(
                          height: 20,
                        ),
                        ...lastBlock(),
                      ],
                    )),
                    _expanded(context),
                  ],
                )),
    );
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
        children: List.generate(
            9,
            (index) => InkWell(
                  onTap: gameOver ? null : () => onTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        Player.playerX.contains(index)
                            ? 'X'
                            : Player.playerO.contains(index)
                                ? 'O'
                                : '',
                        style: TextStyle(
                          color: Player.playerX.contains(index)
                              ? Colors.blue
                              : Colors.pink,
                          fontSize: 52,
                        ),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  List firstBlock() {
    return [
      SwitchListTile.adaptive(
        title: const Text(
          'Turn Off/On two player',
          style: TextStyle(color: Colors.white, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (value) => setState(() {
          isSwitched = value;
        }),
      ),
      Text(
        "It's $activePlayer turn ".toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List lastBlock() {
    return [
      Text(
        "$result".toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 42,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'x';
            gameOver = false;
            turn = 0;
            result = '';
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text('Repeat the game'),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      )
    ];
  }

  onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    return setState(() {
      activePlayer == 'x' ? activePlayer = 'o' : activePlayer = 'x';
      turn++;
      var winner = game.checkWinner();
      if (winner != '') {
        gameOver = true;
        result = '$winner is the winner';
      } else if (!gameOver && turn == 9) {
        result = "It's Draw!";
      }
    });
  }
}
