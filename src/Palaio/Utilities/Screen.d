module Palaio.Utilities.Screen;

import std.string;
import std.stdio;
import std.conv;

import Palaio.Utilities.Log;
import Palaio.Config;

import Derelict.SDL2.sdl;
import Derelict.SDL2.image;
import Derelict.SDL2.ttf;

pragma(lib,"DerelictSDL2.lib");
pragma(lib,"DerelictUtil.lib");

/// Singleton class implementing the screen handling.
class Screen
{
    private:
		static Screen _instance;

        SDL_Renderer *_ren;
        SDL_Window *_win;

        Log _l;

		this()
        {
            _l = Log.getInstance();

            DerelictSDL2.load();
            DerelictSDL2Image.load();
            DerelictSDL2ttf.load();

            if(!TTF_WasInit()) // just because Derelict's bindings for SDL2_TTF are shit
                if(TTF_Init() < 0)
                    _l.write("Error: Can't initialize SDL_TTF: "~to!string(TTF_GetError()));

			_l.write("SDL initialized");

            _win = SDL_CreateWindow(cast(char*) WINDOWTITLE, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, WIDTH, HEIGHT,SDL_WINDOW_SHOWN);
            if(_win is null)
                _l.write("Error: Can't create window: "~to!string(SDL_GetError()));
            else
                _l.write("Window created");

            _ren = SDL_CreateRenderer(_win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
            if(_ren is null)
                _l.write("Error: Can't create renderer: "~to!string(SDL_GetError()));
            else
                _l.write("Renderer created");
        }

		~this()
        {
            SDL_DestroyRenderer(_ren);
            SDL_DestroyWindow(_win);

            // commented for now - Derelict SHOULD unload everything when app quits (but never trust your dev libs...)
            //DerelictSDL2TTF.unload();
            //DerelictSDL2Image.unload();
            //DerelictSDL2.unload();
        }

    public:
		/**
		* Gets the singleton instance of object.
		* Returns: Reference to the object.
		*/
        static ref Screen getInstance()
		{
			if(_instance is null)
				_instance = new Screen();

			return _instance;
		}

		/**
		* Gets texture from an image file.
		* Params:
		*	file =			Filename of an image.
		* Returns: Loaded texture.
		*/
        SDL_Texture* getImageTexture(string file)
        {
            SDL_Texture *tex = IMG_LoadTexture(_ren,cast(char*) file);
            if(tex is null)
                _l.write("Error: in getImageTexture: "~to!string(IMG_GetError()));
            else
                _l.write("Texture from image "~file~" loaded");

            return tex;
        }

		/**
		* Adds texture to the buffer and scales the texture to the specified dimensions.
		* Params:
		*	tex =			Texture.
		*	x =				X coordinate.
		*	y =				Y coordinate.
		*	w =				Width to be scaled to.
		*	h =				Height to be scaled to.
		*/
        void addTexture(SDL_Texture *tex, int x, int y, int w, int h)
        {
            SDL_Rect dst;
            dst.x = x;
            dst.y = y;
            dst.w = w;
            dst.h = h;
            SDL_RenderCopy(_ren, tex, null, &dst);
        }

		/**
		* Adds texture to the buffer.
		* Params:
		*	tex =			Texture.
		*	x =				X coordinate.
		*	y =				Y coordinate.
		*/
        void addTexture(SDL_Texture *tex, int x, int y)
        {
            int w, h;
            SDL_QueryTexture(tex, null, null, &w, &h);
            addTexture(tex, x, y, w, h);
        }

		/**
		* Gets texture of a text.
		* Params:
		*	text =			Text to be written.
		*	fontFile =		Filename of font to be used.
		*	color =			Color of the image.
		*	fontSize =		Size of the font.
		* Returns: Texture.
		*/
        SDL_Texture* getTextTexture(string text, string fontFile, SDL_Color color, int fontSize)
        {
            TTF_Font *font = TTF_OpenFont(cast(char*) fontFile, fontSize);
            if(font is null)
            {
                _l.write("Error: in getTextTexture [TTF_OpenFont]: "~to!string(TTF_GetError()));
                return null;
            }

            SDL_Surface *surf = TTF_RenderText_Blended(font, cast(char*) text, color);
            if(surf is null)
            {
                TTF_CloseFont(font);

                _l.write("Error: in getTextTexture [TTF_RenderText_Blended]: "~to!string(IMG_GetError()));
                return null;
            }

            SDL_Texture *tex = SDL_CreateTextureFromSurface(_ren, surf);
            if (tex is null)
                _l.write("Error: in getTextTexture [SDL_CreateTextureFromSurface]: "~to!string(IMG_GetError()));

            SDL_FreeSurface(surf);
            TTF_CloseFont(font);
            return tex;
        }

		/**
		* Draws a line on the buffer from one point to another.
		* Params:
		*	x0 =			X coordinate of first point.
		*	y0 =			Y coordinate of first point.
		*	x1 =			X coordinate of second point.
		*	y1 =			Y coordinate of second point.
		*	color =			Color of the line.
		*/
        void drawLine(int x0, int y0, int x1, int y1, SDL_Color color)
        {
            ubyte r, g, b, a;
            SDL_GetRenderDrawColor(_ren, &r, &g, &b, &a);
            SDL_SetRenderDrawColor(_ren, cast(ubyte)color.r, cast(ubyte)color.g, cast(ubyte)color.b, 0xFF);
            SDL_RenderDrawLine(_ren, x0, y0, x1, y1);
            SDL_SetRenderDrawColor(_ren, r, g, b, a);
        }

		/// Clears the screen.
        void clear()
        {
            SDL_RenderClear(_ren);
        }

		/// Renders buffer to the screen.
        void renderAll()
        {
            SDL_RenderPresent(_ren);
        }

		/**
		* Shows a simple message box.
		* Params:
		*	title =			Title of the box.
		*	text =			Text of the message.
		*/
        void messageBox(string title, string text)
        {
            SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT, cast(char*)title, cast(char*)text,_win);
        }
}
