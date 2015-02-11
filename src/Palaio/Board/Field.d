module Palaio.Board.Field;

import Palaio.Utilities.Vector;

/// Enum type representing state of a field e.g. if it's empty or occupied by a pawn.
/// Allowed values: FieldState.Empty, FieldState.Green, FieldState.Yellow, FieldState.Block.
enum FieldState
{
	Empty,
	Green,
	Yellow,
	Block
}

/// Class representing the field.
class Field
{
	private:
		int _x;
		int _y;
		FieldState _state;
		Vector!Field _neighbours;

	public:
		/**
		* Creates new field.
		* Params:
		*	x =				X index of a field.
		*	y =				Y index of a field.
		*	fieldState =	[OPTIONAL] State of a field.
		*/
		this(int x, int y, FieldState fieldState = FieldState.Empty)
		{
			_x = x;
			_y = y;
			_state = fieldState;

			_neighbours = new Vector!Field();
		}

		/**
		* Adds a reference to neighbouring field.
		* Params:
		*	neighbour =		Field to be added.
		*/
		void addNeighbour(ref Field neighbour)
		{
			_neighbours.pushBack(neighbour);
		}

		@property
		{
			/// Sets the state of a field.
			void state(FieldState newState) { _state = newState; }

			/// Gets the state of a field.
			FieldState state() { return _state; }

			/// Gets the neighbouring fields vector.
			Vector!Field neighbours() { return _neighbours; }

			/// Gets x index of a field.
			int x() { return _x; }

			/// Gets y index of a field.
			int y() { return _y; }
		}
}
