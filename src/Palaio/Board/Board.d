module Palaio.Board.Board;

import Palaio.Board.Field;

class Board
{
	private:
		Field[][] _fields;
		
	public:
		this()
		{
			// init dynamic, irregular two-dimensional array representing the board...
            _fields.length=7; // because who needs malloc? ;)
            _fields[0].length=5;
            _fields[1].length=6;
            _fields[2].length=7;
            _fields[3].length=8;
            _fields[4].length=7;
            _fields[5].length=6;
            _fields[6].length=5;

			// initialize field objects, so we they can reference themselves later
			for(int i = 0; i < 7; i++)
				for(int j = 0; j < _fields[i].length; j++)
					_fields[i][j] = new Field(j, i);

			for(int i = 0; i < 7; i++)
				for(int j = 0; j < _fields[i].length; j++)
				{
					// calculate connections

					// horizontal ones
					if(j > 0)
						_fields[i][j].addNeighbour(_fields[i][j-1]);

					if(j < _fields[i].length-1)
						_fields[i][j].addNeighbour(_fields[i][j+1]);

					// other connections
					switch(i)
					{
						case 1:
						case 2:
						case 3:
							if(j > 0 && j < _fields[i].length - 1) // is not at the beginning nor at the end of the row
							{
								_fields[i][j].addNeighbour(_fields[i-1][j-1]);
								_fields[i][j].addNeighbour(_fields[i-1][j]);
							}
							else if(j == 0)
								_fields[i][j].addNeighbour(_fields[i-1][j]);
							else if(j == _fields[i].length - 1)
								_fields[i][j].addNeighbour(_fields[i-1][j-1]);
						break;

						case 4:
						case 5:
						case 6:
								_fields[i][j].addNeighbour(_fields[i-1][j]);
								_fields[i][j].addNeighbour(_fields[i-1][j+1]);
						break;

						default:
						break;
					}

					switch(i)
					{
						case 5:
						case 4:
						case 3:
							if(j > 0 && j < _fields[i].length - 1) // is not at the beginning nor at the end of the row
							{
								_fields[i][j].addNeighbour(_fields[i+1][j-1]);
								_fields[i][j].addNeighbour(_fields[i+1][j]);
							}
							else if(j == 0)
								_fields[i][j].addNeighbour(_fields[i+1][j]);
							else if(j == _fields[i].length-1)
								_fields[i][j].addNeighbour(_fields[i+1][j-1]);
						break;

						case 2:
						case 1:
						case 0:
							_fields[i][j].addNeighbour(_fields[i+1][j]);
							_fields[i][j].addNeighbour(_fields[i+1][j+1]);
						break;

						default:
						break;
					}
				}
		}

		this(ref Board board)
		{
			this();

			for(int i = 0; i < 7; i++)
				for(int j = 0; j < _fields[i].length; j++)
					_fields[i][j].state = board.getFieldState(j, i);
		}

		Board clone()
		{
			return new Board(this);
		}

		ref Field getField(int x, int y)
		{
			return _fields[y][x];
		}

		FieldState getFieldState(int x, int y)
		{
			return _fields[y][x].state;
		}
}
