module Palaio.Board.Field;

import Palaio.Utilities.Vector;

enum FieldState
{
	Empty,
	Green,
	Yellow,
	Block
}

class Field
{
	private:
		int _x;
		int _y;
		FieldState _state;
		Vector!Field _neighbours;

	public:
		this(int x, int y, FieldState fieldState = FieldState.Empty)
		{
			_x = x;
			_y = y;
			_state = fieldState;

			_neighbours = new Vector!Field();
		}

		void addNeighbour(ref Field neighbour)
		{
			_neighbours.pushBack(neighbour);
		}

		@property
		{
			void state(FieldState newState) { _state = newState; }
			FieldState state() { return _state; }
			Vector!Field neighbours() { return _neighbours; }
			int x() { return _x; }
			int y() { return _y; }
		}
}
