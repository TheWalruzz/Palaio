module Palaio.GameTwoPlayers;

import Palaio.GameDisplay;
import Palaio.Board.Board;
import Palaio.Board.Move;
import Palaio.Game;

class GameTwoPlayers : Game
{
	private:
		

	public:
		this(BoardArrangement ba = BoardArrangement.Normal)
		{
			super(ba);
		}

		override void run()
		{
			Move tempMove;

			_gd.updateScreen(_board, _ba);

			while(true)
			{
				tempMove = handleClick();
				if(tempMove !is null)
				{
					_board.doMove(tempMove);
					_gd.updateScreen(_board, _ba);
					_turn = ((_turn == Player.Green) ? Player.Yellow : Player.Green);
				}
				else
					return;

				tempMove = handleClick();
				if(tempMove !is null)
				{
					_board.doMove(tempMove);
					_gd.updateScreen(_board, _ba);
					_turn = ((_turn == Player.Green) ? Player.Yellow : Player.Green);
				}
				else
					return;
			}
		}
}
