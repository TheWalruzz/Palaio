module Palaio.Board.Board;

import Palaio.Board.Field;
import Palaio.Board.Move;

/// Enum type representing the players.
/// Allowed values: Player.Green, Player.Yellow.
/// All values correspond to the appropriate FieldState values.
enum Player
{
	Green = FieldState.Green,
	Yellow = FieldState.Yellow
}

/// Class implementing the board.
class Board
{
	private:
		Field[][] _fields;
		int _points[Player];
		
	public:
		/// a simple cheatsheet, just to make sure we don't copy a whole board just to check row's length.
		static const int rowLength[] = [5, 6, 7, 8, 7, 6, 5];

		/// Creates new board object.
		this()
		{
			// init dynamic, irregular two-dimensional array representing the board
			_fields.length = 7;
			for(int i = 0; i < 7; i++)
				_fields[i].length = rowLength[i];

			// initialize field objects, so they can reference themselves later
			for(int i = 0; i < 7; i++)
				for(int j = 0; j <  rowLength[i]; j++)
					_fields[i][j] = new Field(j, i);

			// init the point array
			_points[Player.Green] = 0;
			_points[Player.Yellow] = 0;

			for(int i = 0; i < 7; i++)
				for(int j = 0; j < rowLength[i]; j++)
				{
					// calculate connections

					// horizontal ones
					if(j > 0)
						_fields[i][j].addNeighbour(_fields[i][j-1]);

					if(j <  rowLength[i]-1)
						_fields[i][j].addNeighbour(_fields[i][j+1]);

					// other connections
					switch(i)
					{
						case 1:
						case 2:
						case 3:
							if(j > 0 && j <  rowLength[i] - 1) // is not at the beginning nor at the end of the row
							{
								_fields[i][j].addNeighbour(_fields[i-1][j-1]);
								_fields[i][j].addNeighbour(_fields[i-1][j]);
							}
							else if(j == 0)
								_fields[i][j].addNeighbour(_fields[i-1][j]);
							else if(j ==  rowLength[i] - 1)
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
							if(j > 0 && j <  rowLength[i] - 1) // is not at the beginning nor at the end of the row
							{
								_fields[i][j].addNeighbour(_fields[i+1][j-1]);
								_fields[i][j].addNeighbour(_fields[i+1][j]);
							}
							else if(j == 0)
								_fields[i][j].addNeighbour(_fields[i+1][j]);
							else if(j ==  rowLength[i]-1)
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

		/**
		* Creates a new, shallowly copied board.
		* Params:
		*	board =			Board to copy from.
		*/
		this(ref Board board)
		{
			this();

			for(int i = 0; i < 7; i++)
				for(int j = 0; j < rowLength[i]; j++)
				{
					_fields[i][j].state = board.getFieldState(j, i);
					_points[Player.Green] = board.getPoints(Player.Green);
					_points[Player.Yellow] = board.getPoints(Player.Yellow);
				}
		}

		/**
		* Creates and returns a new, shallowly copied board.
		* Returns: New Board object.
		*/
		Board clone()
		{
			return new Board(this);
		}

		/**
		* Checks if move is valid.
		* Params:
		*	move =			Move to check.
		* Returns: true if move is valid, false otherwise.
		*/
		bool checkMove(ref Move move)
		{
			if(move.startField.checkNeighbour(move.endField))
			{
				if(move.moveType == MoveType.Move)
				{
					if(_fields[move.endField.y][move.endField.x].state == FieldState.Empty)
						return true;

				}
				else if(move.moveType == MoveType.Push)
				{
					if(_fields[move.endField.y][move.endField.x].state == FieldState.Block)
					{
						if(move.startField.y > move.endField.y) // push up
						{
							switch(move.startField.y)
							{
								case 2:
								case 3:
									if(move.endField.x < move.startField.x && move.startField.x > 1) // we push it up-left
									{
										if(_fields[move.endField.y - 1][move.endField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x == move.startField.x && move.startField.x < rowLength[move.startField.y - 1] - 1) // we push it up-right
									{
										if(_fields[move.endField.y - 1][move.endField.x].state == FieldState.Empty)
											return true;
									}
								break;

								case 4:
									if(move.startField.x == 0 && move.endField.x == 0) // special cases of push
									{
										if(_fields[move.endField.y - 1][move.endField.x].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == 6 && move.endField.x == 7)
									{
										if(_fields[move.endField.y - 1][move.endField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == move.endField.x) //up-left
									{
										if(_fields[move.endField.y - 1][move.endField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x > move.startField.x) // up-right
									{
										if(_fields[move.endField.y - 1][move.endField.x].state == FieldState.Empty)
											return true;
									}
								break;

								case 5:
								case 6:
									if(move.startField.x == move.endField.x)
									{
										if(_fields[move.endField.y - 1][move.endField.x].state == FieldState.Empty)
											return true;
									}
									else
									{
										if(_fields[move.endField.y - 1][move.endField.x + 1].state == FieldState.Empty)
											return true;
									}
								break;

								default:
									return false;
								break;
							}
						}
						else if(move.startField.y > move.endField.y) // push down
						{
							switch(move.endField.y) // there's a lot of strange calculations based on our irregular hexagonal board. trust me, it's working
							{
								case 3:
								case 4:
									if(move.endField.x < move.startField.x && move.startField.x > 1) // we push it down-left
									{
										if(_fields[move.endField.y + 1][move.endField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x >= move.startField.x && move.startField.x < rowLength[move.startField.y + 1] - 1) // we push it up-right
									{
										if(_fields[move.endField.y + 1][move.endField.x].state == FieldState.Empty)
											return true;
									}
								break;

								case 2:
									if(move.startField.x == 0 && move.endField.x == 0) // special cases of push
									{
										if(_fields[move.endField.y + 1][move.endField.x].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == 6 && move.endField.x == 7)
									{
										if(_fields[move.endField.y + 1][move.endField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == move.endField.x) //down-left
									{
										if(_fields[move.endField.y + 1][move.endField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x > move.startField.x) // down-right
									{
										if(_fields[move.endField.y + 1][move.endField.x].state == FieldState.Empty)
											return true;
									}
								break;

								case 0:
								case 1:
									if(move.startField.x == move.endField.x) // down-left
									{
										if(_fields[move.endField.y + 1][move.endField.x].state == FieldState.Empty)
											return true;
									}
									else // down-right
									{
										if(_fields[move.endField.y + 1][move.endField.x + 1].state == FieldState.Empty)
											return true;
									}
								break;

								default:
									return false;
								break;
							}
						}
						else
						{
							if(move.endField.x < move.startField.x) // push left
							{
								if(move.endField.x - 1 < 0)
									return false;

								if(_fields[move.endField.y][move.endField.x - 1].state == FieldState.Empty)
									return true;
							}
							else // push right
							{
								if(move.endField.x + 1 >= _fields[move.endField.y].length)
									return false;

								if(_fields[move.endField.y][move.endField.x + 1].state == FieldState.Empty)
									return true;
							}
						}
					}
				}
				else // pull
				{
					if(_fields[move.endField.y][move.endField.x].state == FieldState.Block)
					{
						if(move.startField.y < move.endField.y) // pull up
						{
							switch(move.startField.y)
							{
								case 1:
								case 2:
									if(move.endField.x > move.startField.x && move.startField.x > 0) // pull up-left
									{
										if(_fields[move.startField.y - 1][move.startField.x + 1].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == move.endField.x && move.startField.x < rowLength[move.startField.y] - 1) // pull up-right
									{
										if(_fields[move.startField.y - 1][move.startField.x].state == FieldState.Empty)
											return true;
									}
								break;

								case 3:
									if(move.startField.x == 0 && move.endField.x == 0) // special cases
									{
										if(_fields[move.startField.y - 1][move.startField.x].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == 7 && move.endField.x == 6)
									{
										if(_fields[move.startField.y - 1][move.startField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == move.endField.x) // pull up-left
									{
										if(_fields[move.startField.y - 1][move.startField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x < move.startField.x)
									{
										if(_fields[move.startField.y - 1][move.startField.x].state == FieldState.Empty)
											return true;
									}
								break;

								case 4:
									if(move.startField.x == move.endField.x && move.startField.x < 6) // pull up-left
									{
										if(_fields[move.startField.y - 1][move.startField.x].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x < move.startField.x && move.startField.x > 0) // pull up-right
									{
										if(_fields[move.startField.y - 1][move.startField.x + 1].state == FieldState.Empty)
											return true;
									}
								break;

								default:
									return false;
								break;
							}
						}
						else if(move.startField.y > move.endField.y) // pull down
						{
							switch(move.startField.y)
							{
								case 4:
								case 5:
									if(move.endField.x > move.startField.x && move.startField.x > 0) // pull down-left
									{
										if(_fields[move.startField.y + 1][move.startField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == move.endField.x && move.startField.x < rowLength[move.startField.y + 1] - 1) // pull down-right
									{
										if(_fields[move.startField.y + 1][move.startField.x].state == FieldState.Empty)
											return true;
									}
								break;

								case 3:
									if(move.startField.x == 0 && move.endField.x == 0) // special cases
									{
										if(_fields[move.startField.y + 1][move.startField.x].state == FieldState.Empty)
											return true;
									}
									else if(move.startField.x == 7 && move.endField.x == 6)
									{
										if(_fields[move.startField.y + 1][move.startField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x == move.startField.x) // pull down-left
									{
										if(_fields[move.startField.y + 1][move.startField.x - 1].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x < move.startField.x)
									{
										if(_fields[move.startField.y + 1][move.startField.x].state == FieldState.Empty)
											return true;
									}
								break;

								case 2:
									if(move.startField.x == move.endField.x && move.startField.x < 6) // pull down-left
									{
										if(_fields[move.startField.y + 1][move.startField.x].state == FieldState.Empty)
											return true;
									}
									else if(move.endField.x < move.startField.x && move.startField.x > 0) // pull down-right
									{
										if(_fields[move.startField.y + 1][move.startField.x + 1].state == FieldState.Empty)
											return true;
									}
								break;

								default:
									return false;
								break;
							}
						}
						else
						{
							if(move.endField.x > move.startField.x) // pull left
							{
								if(move.startField.x - 1 < 0)
									return false;

								if(_fields[move.startField.y][move.startField.x - 1].state == FieldState.Empty)
									return true;
							}
							else // pull right
							{
								if(move.startField.x + 1 > rowLength[move.startField.y] - 1)
									return false;

								if(_fields[move.startField.y][move.startField.x + 1].state == FieldState.Empty)
									return true;
							}
						}
					}
				}
			}

			return false;
		}

		/**
		* Applies a move to the board if that move is valid. 
		* Params:
		*	move =			Move to be applied.
		* Returns: true if move was correctly applied, false otherwise.
		*/
		bool doMove(ref Move move)
		{
			if(checkMove(move))
			{
				FieldState player = move.startField.state;

				if(move.moveType != MoveType.Pull)
				{
					_fields[move.startField.y][move.startField.x].state = FieldState.Empty;
					_fields[move.endField.y][move.endField.x].state = player;
				}

				if(move.moveType == MoveType.Push)
				{
					if(move.endField.y < move.startField.y) // if pushing up
						switch(move.startField.y)
						{
							case 2:
							case 3:
								if(move.endField.x < move.startField.x) // left
									_fields[move.endField.y - 1][move.endField.x - 1].state = FieldState.Block;
								else // right
									_fields[move.endField.y - 1][move.endField.x].state = FieldState.Block;
							break;

							case 4:
								// ifs are separated to ensure that expressions with equal signs are checked first
								if(move.startField.x == 0 && move.endField.x == 0) // left edge - special rules apply
									_fields[move.endField.y - 1][move.endField.x].state = FieldState.Block;
								else if(move.startField.x == 6 && move.endField.x == 7) // right edge - special rules apply
									_fields[move.endField.y - 1][move.endField.x - 1].state = FieldState.Block;
								else if(move.startField.x == move.endField.x) // left
									_fields[move.endField.y - 1][move.endField.x - 1].state = FieldState.Block;
								else // right
									_fields[move.endField.y - 1][move.endField.x].state = FieldState.Block;
							break;

							case 5:
							case 6:
								if(move.startField.x == move.endField.x) // left
									_fields[move.endField.y - 1][move.endField.x].state = FieldState.Block;
								else // right
									_fields[move.endField.y - 1][move.endField.x + 1].state = FieldState.Block;
							break;

							default:
								return false;
							break;
						}
					else if(move.endField.y > move.startField.y) // push down
						switch(move.startField.y)
						{
							case 3:
							case 4:
								if(move.startField.x > move.endField.x) // left
									_fields[move.endField.y + 1][move.endField.x - 1].state = FieldState.Block;
								else // right
									_fields[move.endField.y + 1][move.endField.x].state = FieldState.Block;
							break;

							case 2:
								if(move.startField.x == 0 &&  move.endField.x == 0)
									_fields[move.endField.y + 1][move.endField.x].state = FieldState.Block;
								else if(move.startField.x == 6 && move.endField.x == 7)
									 _fields[move.endField.y + 1][move.endField.x - 1].state = FieldState.Block;
								else if(move.startField.x == move.endField.x) // left
									_fields[move.endField.y + 1][move.endField.x - 1].state = FieldState.Block;
								else // right
									_fields[move.endField.y + 1][move.endField.x].state = FieldState.Block;
							break;

							case 1:
							case 0:
								if(move.startField.x == move.endField.x) // left
									_fields[move.endField.y + 1][move.endField.x].state = FieldState.Block;
								else // right
									_fields[move.endField.y + 1][move.endField.x + 1].state = FieldState.Block;
							break;

							default:
								return false;
							break;
						}
					else
					{
						if(move.startField.x < move.endField.x) // push right
							_fields[move.endField.y][move.endField.x + 1].state = FieldState.Block;
						else if(move.startField.x >  move.endField.x)
							_fields[move.endField.y][move.endField.x - 1].state = FieldState.Block;
					}
				}
				else if(move.moveType == MoveType.Pull)
				{
					_fields[move.endField.y][move.endField.x].state = FieldState.Empty;
					_fields[move.startField.y][move.startField.x].state = FieldState.Block;
					
					if(move.startField.y < move.endField.y) // pull up
					{
						switch(move.startField.y)
						{
							case 1:
							case 2:
								if(move.startField.x < move.endField.x) // left
									_fields[move.startField.y - 1][move.startField.x - 1].state = player;
								else
									_fields[move.startField.y - 1][move.startField.x].state = player;
							break;

							case 3:
								if(move.startField.x == 0 && move.endField.x == 0)
									_fields[move.startField.y - 1][move.startField.x].state = player;
								else if(move.startField.x == 7 && move.endField.x == 6)
									_fields[move.startField.y - 1][move.startField.x - 1].state = player;
								else if(move.startField.x == move.endField.x) // left
									_fields[move.startField.y - 1][move.startField.x - 1].state = player;
								else
									_fields[move.startField.y - 1][move.startField.x].state = player;
							break;

							case 4:
								if(move.startField.x == move.endField.x) // left
									_fields[move.startField.y - 1][move.startField.x].state = player;
								else
									_fields[move.startField.y - 1][move.startField.x + 1].state = player;
							break;

							default:
							break;
						}
					}
					else if(move.startField.y > move.endField.y) // pull down
					{
						switch(move.startField.y)
						{
							case 4:
							case 5:
								if(move.startField.x < move.endField.x) // left
									_fields[move.startField.y + 1][move.startField.x - 1].state = player;
								else
									_fields[move.startField.y + 1][move.startField.x].state = player;
							break;

							case 3:
								if(move.startField.x == 0 && move.endField.x == 0)
									_fields[move.startField.y + 1][move.startField.x].state = player;
								else if(move.startField.x == 6 && move.endField.x == 7)
									_fields[move.startField.y + 1][move.startField.x - 1].state = player;
								else if(move.startField.x == move.endField.x) // left
								{
									if(move.startField.x != 7)
										_fields[move.startField.y + 1][move.startField.x - 1].state = player;
									else
										_fields[move.startField.y + 1][move.startField.x].state = player;
								}
								else
								{
									if(move.startField.x != 7)
										_fields[move.startField.y + 1][move.startField.x].state = player;
									else
										_fields[move.startField.y + 1][move.startField.x - 1].state = player;
								}
							break;

							case 2:
								if(move.startField.x == move.endField.x) // left
									_fields[move.startField.y + 1][move.startField.x].state = player;
								else
									_fields[move.startField.y + 1][move.startField.x + 1].state = player;
							break;

							default:
							break;
						}
					}
					else
					{
						if(move.startField.x < move.endField.x) // left
							_fields[move.startField.y][move.startField.x - 1].state = player;
						else
							_fields[move.startField.y][move.startField.x + 1].state = player;
					}
				}

				return true;
			}

			return false;
		}

		/// Clears the board and sets every field's state to Empty.
		void clear()
		{
			for(int i = 0; i < 7; i++)
				for(int j = 0; j < rowLength[i]; j++)
					_fields[i][j].state = FieldState.Empty;
		}
		
		/**
		* Gets Field object of particular field.
		* Params:
		*	x =				X index of the field.
		*	y =				Y index of the field.
		* Returns: Reference to the Field object.
		*/
		ref Field getField(int x, int y)
		{
			return _fields[y][x];
		}

		/**
		* Gets state of particular field.
		* Params:
		*	x =				X index of the field.
		*	y =				Y index of the field.
		* Returns: State of a field.
		*/
		FieldState getFieldState(int x, int y)
		{
			return _fields[y][x].state;
		}

		/**
		* Sets state of particular field.
		* Params:
		*	x =				X index of the field.
		*	y =				Y index of the field.
		*	state =			New state of a field.
		*/
		void setFieldState(int x, int y, FieldState state)
		{
			_fields[y][x].state = state;
		}

		/**
		* Gets the number of points for specified player.
		* Params:
		*	player =			Player to check the points.
		* Returns: Points got by specified player.
		*/
		int getPoints(Player player)
		{
			return _points[player];
		}

		/**
		* Sets the number of points for specified player.
		* Params:
		*	player =			Player to set the points.
		*	points =		Points to set.
		*/
		void setPoints(Player player, int points)
		{
			_points[player] = points;
		}

		/**
		* Adds one point for specified player.
		* Params:
		*	player =			Player to add point.
		*/
		void addPoint(Player player)
		{
			_points[player]++;
		}
}
