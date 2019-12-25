#include "sdl_emu.hpp"

#include <exec/types.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <intuition/screens.h>

#include <exec/memory.h>
#include <exec/interrupts.h>
#include <hardware/intbits.h>
#include <hardware/custom.h>

#include <string>
#include <cassert>

#include "dernc.hpp"

#include "read_joypad.hpp"
#include "MemoryEntryMap.hpp"

static SDLKey MISC_keymap[256];


static struct Screen *screen[2] = {nullptr};
static struct Window *window=0;
static struct RastPort *rastport=0;
static struct ViewPort *viewport=0;
static PLANEPTR *planes_list[2];
static UWORD *copperlist[2] = {nullptr};

//static PLANEPTR *planes;

struct Window *get_window();

static bool first_copperlist_apply = true;

extern struct Custom custom;

void amiga_InitKeymap(void)
{


  /* Map the miscellaneous keys */
  for ( unsigned int i=0; i<SDL_TABLESIZE(MISC_keymap); ++i )
    MISC_keymap[i] = SDLK_UNKNOWN;

  /* These X keysyms have 0xFF as the high byte */
  MISC_keymap[65] = SDLK_BACKSPACE;
  MISC_keymap[66] = SDLK_TAB;
  MISC_keymap[70] = SDLK_CLEAR;
  MISC_keymap[70] = SDLK_DELETE;
  MISC_keymap[68] = SDLK_RETURN;
  //	MISC_keymap[XK_Pause&0xFF] = SDLK_PAUSE;
  MISC_keymap[69] = SDLK_ESCAPE;
  MISC_keymap[70] = SDLK_DELETE;
  /*
	  SDLK_SPACE		= 32,
	  SDLK_MINUS		= 45,
	  SDLK_LESS		= 60,
	  SDLK_COMMA		= 44,
	  SDLK_PERIOD		= 46,
	  SDLK_0			= 48,
	  SDLK_1			= 49,
	  SDLK_2			= 50,
	  SDLK_3			= 51,
	  SDLK_4			= 52,
	  SDLK_5			= 53,
	  SDLK_6			= 54,
	  SDLK_7			= 55,
	  SDLK_8			= 56,
	  SDLK_9			= 57,
	  SDLK_BACKQUOTE		= 96,
	  SDLK_BACKSLASH		= 92,
	  SDLK_a			= 97,
	  SDLK_b			= 98,
	  SDLK_c			= 99,
	  SDLK_d			= 100,
	  SDLK_e			= 101,
	  SDLK_f			= 102,
	  SDLK_g			= 103,
	  SDLK_h			= 104,
	  SDLK_i			= 105,
	  SDLK_j			= 106,
	  SDLK_k			= 107,
	  SDLK_l			= 108,
	  SDLK_m			= 109,
	  SDLK_n			= 110,
	  SDLK_o			= 111,
	  SDLK_p			= 112,
	  SDLK_q			= 113,
	  SDLK_r			= 114,
	  SDLK_s			= 115,
	  SDLK_t			= 116,
	  SDLK_u			= 117,
	  SDLK_v			= 118,
	  SDLK_w			= 119,
	  SDLK_x			= 120,
	  SDLK_y			= 121,
	  SDLK_z			= 122,
   */
  MISC_keymap[15] = SDLK_KP0;		/* Keypad 0-9 */
  MISC_keymap[29] = SDLK_KP1;
  MISC_keymap[30] = SDLK_KP2;
  MISC_keymap[31] = SDLK_KP3;
  MISC_keymap[45] = SDLK_KP4;
  MISC_keymap[46] = SDLK_KP5;
  MISC_keymap[47] = SDLK_KP6;
  MISC_keymap[61] = SDLK_KP7;
  MISC_keymap[62] = SDLK_KP8;
  MISC_keymap[63] = SDLK_KP9;
  MISC_keymap[60] = SDLK_KP_PERIOD;
  MISC_keymap[92] = SDLK_KP_DIVIDE;
  MISC_keymap[93] = SDLK_KP_MULTIPLY;
  MISC_keymap[74] = SDLK_KP_MINUS;
  MISC_keymap[94] = SDLK_KP_PLUS;
  MISC_keymap[67] = SDLK_KP_ENTER;
  //	MISC_keymap[XK_KP_Equal&0xFF] = SDLK_KP_EQUALS;

  MISC_keymap[76] = SDLK_UP;
  MISC_keymap[77] = SDLK_DOWN;
  MISC_keymap[78] = SDLK_RIGHT;
  MISC_keymap[79] = SDLK_LEFT;
  /*
	  MISC_keymap[XK_Insert&0xFF] = SDLK_INSERT;
	  MISC_keymap[XK_Home&0xFF] = SDLK_HOME;
	  MISC_keymap[XK_End&0xFF] = SDLK_END;
   */
  // Mappati sulle parentesi del taastierino
  MISC_keymap[90] = SDLK_PAGEUP;
  MISC_keymap[91] = SDLK_PAGEDOWN;

  MISC_keymap[80] = SDLK_F1;
  MISC_keymap[81] = SDLK_F2;
  MISC_keymap[82] = SDLK_F3;
  MISC_keymap[83] = SDLK_F4;
  MISC_keymap[84] = SDLK_F5;
  MISC_keymap[85] = SDLK_F6;
  MISC_keymap[86] = SDLK_F7;
  MISC_keymap[87] = SDLK_F8;
  MISC_keymap[88] = SDLK_F9;
  MISC_keymap[89] = SDLK_F10;
  //	MISC_keymap[XK_F11&0xFF] = SDLK_F11;
  //	MISC_keymap[XK_F12&0xFF] = SDLK_F12;
  //	MISC_keymap[XK_F13&0xFF] = SDLK_F13;
  //	MISC_keymap[XK_F14&0xFF] = SDLK_F14;
  //	MISC_keymap[XK_F15&0xFF] = SDLK_F15;

  //	MISC_keymap[XK_Num_Lock&0xFF] = SDLK_NUMLOCK;
  MISC_keymap[98] = SDLK_CAPSLOCK;
  //	MISC_keymap[XK_Scroll_Lock&0xFF] = SDLK_SCROLLOCK;
  MISC_keymap[97] = SDLK_RSHIFT;
  MISC_keymap[96] = SDLK_LSHIFT;
  MISC_keymap[99] = SDLK_LCTRL;
  MISC_keymap[99] = SDLK_LCTRL;
  MISC_keymap[101] = SDLK_RALT;
  MISC_keymap[100] = SDLK_LALT;
  //	MISC_keymap[XK_Meta_R&0xFF] = SDLK_RMETA;
  //	MISC_keymap[XK_Meta_L&0xFF] = SDLK_LMETA;
  MISC_keymap[103] = SDLK_LSUPER; /* Left "Windows" */
  MISC_keymap[102] = SDLK_RSUPER; /* Right "Windows */

  MISC_keymap[95] = SDLK_HELP;
}
static void wait_blit()
{
  __asm("TST.B	0xBFE001");
  while(custom.dmaconr & 1<<14) {}
}

static Uint8 key_status[1024] = {0};


// on amigaOS, set_pixel and get_pixel use/return codes which AREN'T rgb values (there is a palette).
// instead it returns the color NUMBER
// note that this is SUPER SLOW. Use only to prepare image buffers, never in real time
void SDL_SetPixel( SDL_Surface* pSurface , int x , int y , Uint32 fake_rgb)
{
  assert(x < pSurface->w);
  assert(y < pSurface->h);
  assert(x >= 0);
  assert(y >= 0);
  SDL_Amiga_Surface *s = (SDL_Amiga_Surface *)pSurface;
  //determine position
  UBYTE *ptr = ( UBYTE *) s->pixels;
  int nb_planes = s->nb_planes;
  if (s->mask != nullptr) {
    // add an extra plane: the cookie cut mask
    nb_planes++;
  }

  //offset by y
  ptr += ( s->w/8 * y ) + x/8;

  int bit = 7 - (x % 8);

  // for each plane compose the value
  for (int i=0;i<nb_planes;i++)
    {
      int set = fake_rgb & 1;
      fake_rgb >>= 1;
      ULONG mask = 1 << bit;
      if (set)
	{
	  (*ptr) |= mask;
	}
      else
	{
	  (*ptr) &= ~mask;
	}
      ptr += s->plane_size;
    }



}


Uint32 SDL_GetPixel( const SDL_Surface* pSurface , int x , int y )
{
  assert(x < pSurface->w);
  assert(y < pSurface->h);
  assert(x >= 0);
  assert(y >= 0);
  Uint32 col = 0 ;
  SDL_Amiga_Surface *s = (SDL_Amiga_Surface *)pSurface;
  //determine position
  UBYTE *ptr = ( UBYTE *) s->pixels ;
  int nb_planes = s->nb_planes;
  if (s->mask != nullptr) {
    // add an extra plane: the cookie cut mask
    nb_planes++;
  }
  //offset by y
  ptr += ( s->w/8 * y ) + x/8;

  int bit = 7 - (x % 8);

  // for each plane compose the value

  for (int i=0;i<nb_planes;i++)
    {
      col |= (((*ptr) >> bit) & 1)<<nb_planes;
      col >>= 1;
      ptr += s->plane_size;
    }

  return col;
}

static int GetChar(BPTR f)
{
  unsigned char r=0;
  int nb_read = Read(f,&r,1);

  return (nb_read==1) ? r : -1;


}


#define UNSUPPORTED_FUNCTION(f) assert(false and "unsupported " f)
extern "C"
{
  void SDLCALL SDL_WM_SetCaption(const char *, const char *)
  {
  }

  int SDLCALL SDL_OpenAudio(SDL_AudioSpec *, SDL_AudioSpec *)
  {
    return 0;
  }
  SDL_RWops * SDLCALL SDL_RWFromFile(const char *filename, const char *mode)
  {
    (void)mode;  // can't write stuff!!
    BPTR f = Open(filename,MODE_OLDFILE);
    SDL_RWops *rval = NULL;
    if (f!=0)
      {
	rval = new SDL_RWops();
	rval->hidden.stdio.fp = (FILE*)f;
      }
    return rval;
  }


  SDL_Surface * SDLCALL SDL_LoadBMP_RW(SDL_RWops *handle, int )
  {

    SDL_Amiga_Surface *surface = NULL;
    size_t nb_read;
    if (handle)
      {
	// size is encoded first
	BPTR f = (BPTR)handle->hidden.stdio.fp;
	ULONG fourcc;
	Read(f,&fourcc,4);
	if (fourcc == 0x524E4301) // RNC
	  {
	    // read the file fully
	    Seek(f,0,OFFSET_END);
	    ULONG size = Seek(f,0,OFFSET_CURRENT);
	    unsigned char *packed = new unsigned char[size];
	    Seek(f,0,OFFSET_BEGINNING);
	    Read(f,packed,size);
	    ULONG unpacked_len = rnc_ulen (packed);
	    unsigned char *unpacked = new unsigned char[unpacked_len];
	    rnc_unpack (packed, unpacked);

	    delete [] packed;
	    int i=0;
	    unsigned char w1 = unpacked[i++];
	    unsigned char w2 = unpacked[i++];
	    unsigned char h1 = unpacked[i++];
	    unsigned char h2 = unpacked[i++];

	    int nb_planes = unpacked[i++];

	    SDL_Amiga_Surface::ImageType image_type = (SDL_Amiga_Surface::ImageType)unpacked[i++];

	    int flags = image_type==SDL_Amiga_Surface::SHIFTABLE_TRANSPARENT_BOB ? SDL_SRCALPHA : 0;

	    surface = (SDL_Amiga_Surface *)SDL_CreateRGBSurface(flags,w1*256 + w2,h1*256 + h2,nb_planes,0,0,0,0);

	    // sprite or planes (0: planes)
	    surface->image_type = image_type;
	    nb_read = unpacked_len - i;
	    memcpy(surface->pixels,unpacked+i,nb_read);

	    delete [] unpacked;
	  }
	else
	  {
	    unsigned char w1 = GetChar(f);
	    unsigned char w2 = GetChar(f);
	    unsigned char h1 = GetChar(f);
	    unsigned char h2 = GetChar(f);

	    int nb_planes = GetChar(f);

	    SDL_Amiga_Surface::ImageType image_type = (SDL_Amiga_Surface::ImageType)GetChar(f);

	    int flags = image_type==SDL_Amiga_Surface::SHIFTABLE_TRANSPARENT_BOB ? SDL_SRCALPHA : 0;

	    surface = (SDL_Amiga_Surface *)SDL_CreateRGBSurface(flags,w1*256 + w2,h1*256 + h2,nb_planes,0,0,0,0);

	    // sprite or planes (0: planes)
	    surface->image_type = image_type;
	    nb_read = Read(f,surface->pixels,surface->buffer_size);

	  }

	Close(f);


	if (nb_read != surface->buffer_size)
	  {
	    // corrupt not enough data (doesn't happen if conversion is correct)
	    printf("%d != %d\n",int(nb_read), int(surface->buffer_size));
	    assert(false);
	  }

      }

    LOGGED_DELETE(handle);
    return surface;
  }

  /*The width and height in srcrect determine the size of the copied rectangle.
    Only the position is used in the dstrect (the width and height are ignored). Blits with negative dstrect coordinates will be clipped properly.

    If srcrect is NULL, the entire surface is copied. If dstrect is NULL, then the destination position (upper left corner) is (0, 0).

    The final blit rectangle is saved in dstrect after all clipping is performed (srcrect is not modified).
   */

  int SDLCALL SDL_UpperBlit
    (SDL_Surface *source, SDL_Rect *src_rect,
    SDL_Surface *destination, SDL_Rect *dst_rect)
  {

    SDL_Amiga_Surface *amiga_source = (SDL_Amiga_Surface *)(source);
    SDL_Amiga_Surface *amiga_destination = (SDL_Amiga_Surface *)(destination);
    SDL_Rect src_clip;
    if (src_rect == nullptr)
      {
	// no source rect: clip bounds are source bounds
	src_clip.x = 0;
	src_clip.y = 0;
	src_clip.w = source->w;
	src_clip.h = source->h;
      }
    else
      {
	src_clip = *src_rect;
      }



    SDL_Rect dst_clip;
    //dst_clip.w = destination->w;
    //dst_clip.h = destination->h;

    if (dst_rect == nullptr)
      {
	// no source rect: clip bounds are source bounds
	dst_clip.x = 0;
	dst_clip.y = 0;
      }
    else
      {
	dst_clip.x = dst_rect->x;
	dst_clip.y = dst_rect->y;
      }


    // clipping to avoid that a bob writes past end of the screen
    // handle blitting out of target bounds
    if (dst_clip.x < 0)
      {
	// remove left part
	src_clip.x -= dst_clip.x;  // increase source x
	src_clip.w += dst_clip.x;  // reduce source width
	dst_clip.x = 0;  // dest at 0 instead
      }
    else if (dst_clip.x+src_clip.w > destination->w)
      {
	// remove right part
	src_clip.w = destination->w - dst_clip.x;
      }

    if (dst_clip.y < 0)
      {
	// remove left part
	src_clip.y -= dst_clip.y;
	src_clip.h += dst_clip.y;
	dst_clip.y = 0;
      }
    else if (dst_clip.y+src_clip.h > destination->h)
      {
	// remove right part
	src_clip.h = destination->h - dst_clip.y;
      }



    if (source->w < 16 or src_clip.w <16)
      {
	// not using the blitter. Slow but not a problem if those objects aren't written
	// frequently
	// an optimization could be to copy a byte if width is exactly 8 and x is divisible by 8...
	// happens a lot with fonts and all
	// we're also not optimizing if source has a mask or has clipping
	// this is designed to optimize for 8x8 objects copied at x being multiple of 8

	if ((dst_clip.x & 0x7) == 0 and src_clip.w == 8 and (src_clip.x & 0x7) == 0 and not amiga_source->mask)
	  {
	    int snb_cols = amiga_source->w>>3;
	    UBYTE *srcptr = (UBYTE *)amiga_source->pixels + (src_clip.x>>3) + src_clip.y*(snb_cols);
	    int dnb_cols = amiga_destination->w>>3;
	    UBYTE *dstptr = (UBYTE*)amiga_destination->pixels + (dst_clip.x>>3) + dst_clip.y*(dnb_cols);

	    for (int p=0;p < NB_PLANES; p++)
	      {
		int doffset = 0;
		int soffset = 0;
		for (int i=0;i<src_clip.h; i++)
		  {
		    dstptr[doffset] = srcptr[soffset];
		    doffset += dnb_cols;
		    soffset += snb_cols;

		  }
		dstptr += amiga_destination->plane_size;
		srcptr += amiga_source->plane_size;

	      }
	  }
	else
	  {
	    for (int y=0; y < src_clip.h; y++)
	      {
		for (int x=0; x < src_clip.w; x++)
		  {
		    SDL_SetPixel(destination,x+dst_clip.x,y+dst_clip.y,SDL_GetPixel(source,x+src_clip.x,y+src_clip.y));
		  }
	      }
	  }
      }
    else
      {

	if ((src_clip.y >= source->h) or (src_clip.x >= source->w))
	  {
	    // x/y clip start too high: don't draw
	    return 0;
	  }
	// safety: limit source width if too wide / image width
	if (src_clip.x + src_clip.w > source->w)
	  {
	    src_clip.w = source->w - src_clip.x;
	  }
	// safety: limit source height if too wide / image height
	if (src_clip.y + src_clip.h > source->h)
	  {
	    src_clip.h = source->h - src_clip.y;
	  }
	if ((src_clip.w <= 0) or (src_clip.h <= 0))
	  {
	    // if width or height end up being negative, don't blit anything
	    return 0;
	  }

	int nb_planes = NB_PLANES;

	src_clip.w &= 0xFF0;  // temp align width on 16 bits

	bool cookie_cut_mode = (amiga_source->image_type == SDL_Amiga_Surface::SHIFTABLE_TRANSPARENT_BOB);
	if (cookie_cut_mode and amiga_destination->image_type == SDL_Amiga_Surface::SHIFTABLE_TRANSPARENT_BOB)
	  {
	    // cancel cookie cut more, copy planes and mask as is
	    cookie_cut_mode = false;
	    nb_planes++;
	  }

	UBYTE *srcptr = (UBYTE *)amiga_source->pixels + (src_clip.x>>3);
	UBYTE *maskptr = amiga_source->mask;  // can be null
	if (src_clip.y)
	  {
	    int srcoffset =  src_clip.y * ((amiga_source->w)>>3);
	    srcptr += srcoffset;
	    if (cookie_cut_mode)
	      {
		maskptr += srcoffset;
	      }
	  }

	UBYTE *dstptr = (UBYTE*)amiga_destination->pixels + (dst_clip.x>>3) + dst_clip.y*(amiga_destination->w>>3);

	UWORD shift_value = dst_clip.x;
	UWORD srcxclip_rem = src_clip.x & 0xF;
	if (srcxclip_rem)
	  {
	    shift_value += 16 - srcxclip_rem;
	    dstptr -= 2;
	    src_clip.w += 16;

	    custom.bltafwm = (0xFFFF >> srcxclip_rem);
	  }
	else
	  {
	    custom.bltafwm = 0xFFFF;
	  }

	custom.bltalwm = 0xFFFF;


	UWORD xshift = (amiga_source->image_type == SDL_Amiga_Surface::BOB ? 0 : (((shift_value) & 0xF) << 12));

	/*if (src_clip.x != 0 or src_clip.y != 0)
	  {
	    printf("UpperBlit: src x=%d, src y=%d, w=%d, h=%d, dest x=%d, dest y=%d\n",src_clip.x,src_clip.y,
		   src_clip.w,src_clip.h,dst_clip.x,dst_clip.y); }*/

	wait_blit();
	OwnBlitter();

	custom.dmacon = 0x8040;   // dirty enable blit
	custom.dmacon = 0x0020;   // no sprites for god's sake!

	// compute shift mask too if shiftable bob (else leave at 0)
	custom.bltcon1 = 0x0000 | xshift;
	if (not cookie_cut_mode)
	  {
	    // no cookie cut: blit overwrites what's underneath
	    //move.l #$09f00000,bltcon0(a5)	;A->D copy, no shifts, ascending mode
	    custom.bltcon0 = 0x09f0 | xshift;
	  }
	else
	  {
	    // cookie cut
	    // thanks for help found in this thread: http://eab.abime.net/showthread.php?p=1359724#post1359724
	    // quoting mcgeezer:
	    // "You have to feed the blitter with a mask of your sprite through channel A,
	    // you feed your actual bob bitmap through channel B, and you feed your pristine background through channel C."

	    // setting the proper mintern value + shift
	    custom.bltcon0 = 0x0fca | xshift;

	  }

	UWORD source_modulo = (amiga_source->w-src_clip.w)>>3;
	UWORD dest_modulo = (amiga_destination->w-src_clip.w)>>3;
	//move.l #$ffffffff,bltafwm(a5)	;no masking of first/last word
	custom.bltamod = source_modulo;
	//move.w #0,bltamod(a5)		;A modulo=bytes to skip between lines
	custom.bltdmod = dest_modulo;



	if (cookie_cut_mode)
	  {
	    custom.bltbmod = source_modulo;
	    custom.bltcmod = dest_modulo;

	  }

	auto asrcbw = src_clip.w>>4;
	// BLTSIZE=height*64+width(words: so width divided by 16 and min 1)
	UWORD blit_size = src_clip.h*64+asrcbw;


	for (int i=0;i<nb_planes;i++)
	  {
	    if (cookie_cut_mode)
	      {
		custom.bltbpt = srcptr;
		custom.bltcpt = dstptr;
		custom.bltapt = maskptr;
	      }
	    else
	      {
		custom.bltapt = srcptr;
	      }



	    custom.bltdpt = dstptr;
	    // BLTSIZE=height*64+width(words: so width divided by 16 and min 1)
	    custom.bltsize = blit_size;

	    //move.l a0,bltapt(a5)	;source graphic top left corner
	    //move.l a3,bltdpt(a5)	;destination top left corner
	    //move.w #blith*64+blitw,bltsize(a5)	;rectangle size, starts blit

	    srcptr += amiga_source->plane_size;
	    dstptr += amiga_destination->plane_size;
	    wait_blit();
	  }
	DisownBlitter();
      }

    return 0;
  }

  SDL_Surface * SDLCALL SDL_CreateRGBSurface
    (Uint32 flags, int width, int height, int,
    Uint32 , Uint32 , Uint32 , Uint32 )
  {
    SDL_Amiga_Surface *surface = new SDL_Amiga_Surface();

    surface->w = width;
    surface->h = height;
    surface->w = width;  // actual image width
    surface->nb_planes = NB_PLANES;
    bool has_mask = (flags & SDL_SRCALPHA);



    surface->plane_size = (surface->w*surface->h)/8;
    surface->buffer_size = surface->plane_size * surface->nb_planes;

    if (has_mask)
      {
	// one more plane for the mask
	surface->buffer_size += surface->plane_size;
	// note the extra plane
	surface->image_type = SDL_Amiga_Surface::SHIFTABLE_TRANSPARENT_BOB;
      }

    surface->pixels = AllocMem(surface->buffer_size,MEMF_CHIP);
    if (has_mask)
      {
	// direct access to mask bitmap
	surface->mask = (UBYTE*)surface->pixels + surface->plane_size * surface->nb_planes;
      }
    assert(surface->pixels != 0);
    return surface;
  }


  Uint32 SDLCALL SDL_MapRGB
    (const SDL_PixelFormat * const ,
    const Uint8 , const Uint8 , const Uint8 )
  {
    //  UNSUPPORTED_FUNCTION("SDL_MapRGB");
    return 0;
  }

  int SDLCALL SDL_SetColors(SDL_Surface *,
			    SDL_Color *, int , int)
  {
    UNSUPPORTED_FUNCTION("SDL_SetColors");
    return 0;
  }

  // taken from https://github.com/amigageek/modsurfer/

#define BLTCON0_ASH0_SHF 0xC
#define BLTCON0_USEA     0x0800
#define BLTCON0_USEB     0x0400
#define BLTCON0_USEC     0x0200
#define BLTCON0_USED     0x0100
#define BLTCON0_LF0_SHF  0x0
#define BLTCON1_BSH0_SHF 0xC
#define BLTCON1_TEX0_SHF 0xC
#define BLTCON1_SIGN_SHF 0x6
#define BLTCON1_AUL_SHF  0x2
#define BLTCON1_SING_SHF 0x1
#define BLTCON1_IFE      0x0008
#define BLTCON1_DESC     0x0002
#define BLTCON1_LINE     0x0001
#define BLTSIZE_H0_SHF   0x6
#define BLTSIZE_W0_SHF   0x0
#define BPLCON0_BPU_SHF  0xC
#define BPLCON0_COLOR    0x0200
#define BPLCON3_SPRES_Shf 0x6
#define COPCON_CDANG     0x2
#define DIWHIGH_H10_SHF  0xD
#define DIWHIGH_V8_SHF   0x8
#define DIWSTOP_V0_SHF   0x8
#define DIWSTRT_V0_SHF   0x8
#define DMACON_SET       0x8000
#define DMACON_CLEARALL  0x7FFF
#define DMACON_BLITPRI   0x0400
#define DMACON_DMAEN     0x0200
#define DMACON_BPLEN     0x0100
#define DMACON_COPEN     0x0080
#define DMACON_BLTEN     0x0040
#define DMACON_SPREN     0x0020
#define DMACONR_BBUSY    0x4000
#define INTENA_SET       0x8000
#define INTENA_CLEARALL  0x7FFF
#define INTENA_PORTS     0x0008
#define INTREQ_SET       0x8000
#define INTREQ_CLEARALL  0x7FFF
#define JOYxDAT_XALL     0x00FF
#define JOYxDAT_Y1       0x0200
#define JOYxDAT_X1       0x0002
#define SPRxCTL_EV0_SHF  0x8
#define SPRxCTL_ATT_SHF  0x7
#define SPRxCTL_SV8_SHF  0x2
#define SPRxCTL_EV8_SHF  0x1
#define SPRxCTL_SH0_SHF  0x0
#define SPRxPOS_SV0_SHF  0x8
#define SPRxPOS_SH1_SHF  0x0
#define VHPOSR_VALL      0xFF00
#define VPOSR_V8         0x0001
#define kBytesPerWord 0x2

  static void blit_rect(APTR dst_base,
			UWORD dst_stride_b,
			UWORD dst_x,
			UWORD dst_y,
			APTR mask_base,
			UWORD mask_stride_b,
			UWORD mask_x,
			UWORD mask_y,
			UWORD width,
			UWORD height,
			BOOL set_bits) {
    UWORD start_x_word = dst_x >> 4;
    UWORD end_x_word = ((dst_x + width) + 0xF) >> 4;
    UWORD width_words = end_x_word - start_x_word;
    UWORD word_offset = dst_x & 0xF;

    UWORD dst_mod_b = dst_stride_b - (width_words * kBytesPerWord);
    UWORD mask_mod_b = mask_stride_b - (width_words * kBytesPerWord);

    ULONG dst_start_b = (ULONG)dst_base + (dst_y * dst_stride_b) + (start_x_word * kBytesPerWord);
    ULONG mask_start_b = (ULONG)mask_base + (mask_y * mask_stride_b) + (start_x_word * kBytesPerWord);

    UWORD left_word_mask = (UWORD)(0xFFFFU << (word_offset + std::max(0, 0x10 - (word_offset + width)))) >> word_offset;
    UWORD right_word_mask;

    if (width_words == 1) {
      right_word_mask = left_word_mask;
    }
    else {
      right_word_mask = 0xFFFFU << std::min(0x10, ((start_x_word + width_words) << 4) - (dst_x + width));
    }

    UWORD minterm = 0xA;

    if (mask_base) {
      minterm |= set_bits ? 0xB0 : 0x80;
    }
    else {
      minterm |= set_bits ? 0xF0 : 0x00;
    }

    wait_blit();

    // A = Mask of bits inside copy region
    // B = Optional bitplane mask
    // C = Destination data (for region outside mask)
    // D = Destination data
    custom.bltcon0 = BLTCON0_USEC | BLTCON0_USED | (mask_base ? BLTCON0_USEB : 0) | minterm;
    custom.bltcon1 = 0;
    custom.bltbmod = mask_mod_b;
    custom.bltcmod = dst_mod_b;
    custom.bltdmod = dst_mod_b;
    custom.bltafwm = left_word_mask;
    custom.bltalwm = right_word_mask;
    custom.bltadat = 0xFFFF;
    custom.bltbpt = (APTR)mask_start_b;
    custom.bltcpt = (APTR)dst_start_b;
    custom.bltdpt = (APTR)dst_start_b;
    custom.bltsize = (height << BLTSIZE_H0_SHF) | width_words;
  }


  // here color is NOT the real RGB value, rather the index of the color in the palette

  int SDLCALL SDL_FillRect(SDL_Surface *dst, SDL_Rect *dst_rect, Uint32 color)
  {
    SDL_Rect dst_clip;
    SDL_Amiga_Surface *amiga_destination = (SDL_Amiga_Surface *)(dst);


    if (dst_rect == nullptr)
      {
	// no source rect: clip bounds are destination bounds
	dst_clip.x = 0;
	dst_clip.y = 0;
	dst_clip.w = dst->w;
	dst_clip.h = dst->h;
      }
    else
      {
	dst_clip = *dst_rect;
	if (dst_clip.x < 0)
	  {
	    dst_clip.w += dst_clip.x;
	    dst_clip.x = 0;
	  }
	else if (dst_clip.x + dst_clip.w > dst->w)
	  {
	    dst_clip.w  = dst->w - dst_clip.x;
	  }

	if (dst_clip.y < 0)
	  {
	    dst_clip.h += dst_clip.y;
	    dst_clip.y = 0;
	  }
	else if (dst_clip.y + dst_clip.h  > dst->h)
	  {
	    dst_clip.h  = dst->h - dst_clip.y;
	  }

	if (dst_clip.h <=0 or dst_clip.w <= 0)
	  {

	    return 0;
	  }

      }

    //int dnb_cols = amiga_destination->w >> 3;
    // now that the destination x,y,w,h have been corrected and can be trusted, start the operation
    UBYTE *dstptr = (UBYTE*)amiga_destination->pixels;// + (dst_clip.x>>3) + dst_clip.y*(dnb_cols);
    int nb_cols = amiga_destination->w >> 3;

    OwnBlitter();
    custom.dmacon = 0x8040;   // dirty enable blit



    for (int i=0;i<amiga_destination->nb_planes;i++)
      {

	blit_rect(dstptr,
		  nb_cols,
		  dst_clip.x,
		  dst_clip.y,
		  nullptr,
		  0,
		  0,
		  0,
		  dst_clip.w,
		  dst_clip.h,
		  !!(color & (1<<i)));


	dstptr += amiga_destination->plane_size;

      }
    DisownBlitter();


    return 0;
  }


  void SDLCALL SDL_PauseAudio(int /*pause_on*/)
  {

  }
  void SDLCALL SDL_MixAudio(Uint8 *, const Uint8 *, Uint32 , int )
  {

  }

  int SDL_SaveBMP_RW(SDL_Surface *, SDL_RWops *, int )
  {
    return 0;
  }

  void SDLCALL SDL_FreeSurface(SDL_Surface *surface)
  {
    (void)surface;
  }


  SDL_Surface * SDLCALL SDL_SetVideoMode(int width, int height, int bpp, Uint32 flags)
  {
    (void)flags;
    (void)bpp;

    SDL_Amiga_Surface *screen = new SDL_Amiga_Surface();
    screen->w = width;
    screen->h = height;
    screen->nb_planes = NB_PLANES;

    screen->plane_size = width/8 * height;
    screen->buffer_size =  screen->plane_size * screen->nb_planes;
    // we assume that planes memory is contiguous...
    screen->pixels = planes_list[1][0];
    return screen;
  }


  int SDLCALL SDL_LockSurface(SDL_Surface *)
  {

    return 0;
  }

  /*  On hardware that supports double-buffering, this function sets up a flip and returns.
      The hardware will wait for vertical retrace, and then swap video buffers before the next video surface blit
      or lock will return. On hardware that doesn't support double-buffering, this is equivalent to calling SDL_UpdateRect(screen, 0, 0, 0, 0) */

  static int copper_index = 0;

  static void apply_copperlist(UWORD *copperlist)
  {
    if (first_copperlist_apply)
      {
	Forbid();
	LoadView(nullptr);
	WaitTOF();
	WaitTOF();
	APTR zerochip = AllocMem(64,MEMF_CHIP|MEMF_CLEAR);

	// explicitly clear sprite DMA, we're not using sprites
	// turn off dma
	custom.dmacon = 0x7FFF;
	for (int i=0;i<8;i++)
	  {
	    custom.spr[i].pos = 400; //SPRxCTL
	    custom.spr[i].ctl = 0; //SPRxCTL
	    custom.sprpt[i] = zerochip;
	  }

      }

    custom.cop1lc = (ULONG)copperlist;
    custom.copjmp1 = 0;

    if (first_copperlist_apply)
      {
	custom.diwstrt = 0x3081;
	custom.diwstop = 0x18C1;  // empiric
	custom.ddfstrt = 0x0038;
	custom.ddfstop = 0x00D0;
	custom.bplcon0 = 0x4200;
	custom.bplcon1 = 0;
	custom.bplcon2 = 0;
	custom.bpl1mod = 0;
	custom.bpl2mod = 0;

	custom.dmacon = 0x83C0;

	//Permit();
      }
    first_copperlist_apply = false;
  }

  int SDLCALL SDL_Flip(SDL_Surface *screen)
  {
    screen->pixels = planes_list[copper_index][0];
    copper_index ^= 1;

    // set other copperlist

    /*while (true)
      {
	int x = custom.vhposr;
	if (x>0xFF00) break;
      }*/
    WaitTOF();

    apply_copperlist(copperlist[copper_index]);

    // toggle
    return 0;
  }

  SDL_Surface * SDLCALL SDL_DisplayFormat(SDL_Surface *s)
  {
    // copy everything
    SDL_Amiga_Surface *surface = new SDL_Amiga_Surface(*((SDL_Amiga_Surface *)s));
    // now copy the data
    surface->pixels = AllocMem(surface->buffer_size,MEMF_CHIP);
    memcpy(surface->pixels,s->pixels,surface->buffer_size);
    return surface;
  }

  int SDLCALL SDL_SetColorKey
    (SDL_Surface *, Uint32 , Uint32 )
  {
    return 0;
  }

  void SDLCALL SDL_UnlockSurface(SDL_Surface *)
  {

  }

  void SDLCALL SDL_JoystickClose(SDL_Joystick *)
  {
  }


  // no alpha channel, sorry...
  int SDLCALL SDL_SetAlpha(SDL_Surface *,Uint32, Uint8)
  {
    return 0;
  }

  int SDLCALL SDL_ShowCursor(int)
  {
    return 0;
  }


  void SDLCALL SDL_Quit()
  {
  }

  void SDLCALL SDL_Delay(Uint32 ms)
  {
    // convert milliseconds since each tick means 20 milliseconds

    Delay(ms<20 ? 1 : ms/20);
  }
  static int decode_and_reply_intuition_message(SDL_Event *event,struct Message *msg)
  {
    struct IntuiMessage * imsg = (struct IntuiMessage *)msg;
    ULONG cls = imsg->Class;
    int retcode = 0;

    if (cls == IDCMP_VANILLAKEY)
      {
	event->type = SDL_KEYDOWN;
	UWORD code = imsg->Code;
	event->key.keysym.sym = (SDLKey)code;
	retcode = 1;
      }

    ReplyMsg(msg);
    return retcode;
  }

  int SDLCALL SDL_WaitEvent(SDL_Event *event)
  {
    struct Window *window = get_window();
    struct Message *msg;
    while(1)
      {
	WaitPort(window->UserPort);
	msg = GetMsg(window->UserPort);
	if (msg != NULL)
	  {
	    if (decode_and_reply_intuition_message(event,msg))
	      {
		break;
	      }
	  }

      }
    // event always processed!
    return 1;
  }
  int SDLCALL SDL_PollEvent(SDL_Event *event)
  {
    struct Window *window = get_window();
    struct Message *msg = GetMsg(window->UserPort);
    if (msg != NULL)
      {
	return (decode_and_reply_intuition_message(event,msg));
      }
    return 0;
  }
  Uint8 * SDLCALL SDL_GetKeyState(int *numkeys)
  {

    if (numkeys != nullptr)
      {
	*numkeys = 0;
      }
    //static ULONG previous_key_pressed = 0;

    ULONG joy_state = read_joystick(1);
    /*
       ULONG key_pressed = read_keypress();
       if (key_pressed != previous_key_pressed)
       {
	key_status[SDLK_p] = (joy_state & JPF_BTN_PLAY) or (key_pressed == 0x19);
	key_status[SDLK_ESCAPE] = key_pressed == 0x45 or (joy_state & (JPF_BTN_REVERSE|JPF_BTN_FORWARD|JPF_BTN_PLAY));

       }
       else
       {
	key_status[SDLK_p] = (joy_state & JPF_BTN_PLAY);
	key_status[SDLK_ESCAPE] = bool(joy_state & (JPF_BTN_REVERSE|JPF_BTN_FORWARD|JPF_BTN_PLAY));

       }*/

    int firestatus = bool(joy_state & JPF_BTN_RED);
    key_status[SDLK_RCTRL] = firestatus;
    key_status[SDLK_LCTRL] = firestatus;


    key_status[SDLK_UP] = bool(joy_state & JPF_BTN_UP);
    key_status[SDLK_DOWN] = bool(joy_state & JPF_BTN_DOWN);
    key_status[SDLK_RIGHT] = bool(joy_state & JPF_BTN_RIGHT);
    key_status[SDLK_LEFT] = bool(joy_state & JPF_BTN_LEFT);

    // key_status[SDLK_p] = (joy_state & JPF_BTN_PLAY) or (key_pressed == 0x19);
    //key_status[SDLK_ESCAPE] = bool(joy_state & (JPF_BTN_REVERSE|JPF_BTN_FORWARD|JPF_BTN_PLAY));

    //previous_key_pressed = key_pressed;
    return key_status;
  }
  int SDLCALL SDL_NumJoysticks(void)
  {
    return 2;
  }

  Uint8 SDLCALL SDL_JoystickGetButton(SDL_Joystick *joystick, int button)
  {
    (void)joystick;
    (void)button;
    return 0;
  }
  Sint16 SDLCALL SDL_JoystickGetAxis(SDL_Joystick *joystick, int axis)
  {
    (void)joystick;
    (void)axis;
    return 0;
  };

  static volatile Uint32 ticks=0;

  void SDL_PumpEvents()
  {
    SDL_Event event;
    while(SDL_PollEvent(&event))
      {
	if (event.type == SDL_KEYDOWN)
	  {
	    key_status[event.key.keysym.sym]=1;
	  }
	else if (event.type == SDL_KEYUP)
	  {
	    key_status[event.key.keysym.sym]=0;
	  }
      }

  }
  void SDL_JoystickUpdate()
  {
  }

  Uint32 SDL_GetTicks()
  {
    return ticks*20;
  }
  static struct Interrupt interrupt;
  SDL_NewTimerCallback vbl_callback;
  void *vbl_param = NULL;

  static void vbl_int()
  {
    custom.color[0] = 0xF00;

    ticks ++;

    (*vbl_callback)(20, vbl_param);
    __asm("clr  d0");   // successfully clears Z so interrupt chain isn't broken
  }


  SDL_TimerID SDLCALL SDL_AddTimer(Uint32 interval, SDL_NewTimerCallback callback, void *param)
  {
    (void)interval;
    interrupt.is_Code = &vbl_int;
    interrupt.is_Data = NULL;
    interrupt.is_Node.ln_Type = NT_INTERRUPT;
    interrupt.is_Node.ln_Pri = 100;
    interrupt.is_Node.ln_Name = (char *)"vbl";
    vbl_callback = callback;
    vbl_param = param;

    AddIntServer(INTB_VERTB, &interrupt);
    return (SDL_TimerID)1;
  }

  char * SDLCALL SDL_GetError(void)
  {
    return (char*)"unknown error";
  }

  SDL_bool SDLCALL SDL_RemoveTimer(SDL_TimerID t)
  {
    (void)t;
    return SDL_bool(1);
  }
  SDL_Joystick * SDLCALL SDL_JoystickOpen(int device_index)
  {
    (void)device_index;
    return NULL;
  }

  void open_screen();

  extern int SDLCALL SDL_Init(Uint32 flags)
  {
    (void)flags;
    amiga_InitKeymap();

    open_screen();


    return 0;
  }


};

void close_screen()
{
  if (window)
    {
      CloseWindow(window);
      window = 0;
    }

  for (int i=0;i<2;i++)
    {
      if (screen[i])
	{
	  CloseScreen(screen[i]);
	  screen[i]  =0;
	}


    }
}

void fatal_error(const char *message)
{
  fprintf(stderr,"%s\n",message);
  close_screen();

}




struct Window *get_window()
{
  return window;
}



static UWORD *make_copperlist(const UWORD rgb[], int nb_colors, PLANEPTR *planes)
{
  // size of copperlist: bitplane set + colors + end
  UWORD *copperlist = (UWORD *)AllocMem((NB_PLANES * 8) + (1<<NB_PLANES)*4 + 20,MEMF_CHIP);
  UWORD *cptr = copperlist;

  assert(1<<NB_PLANES >= nb_colors);

  int i;
  // colormap
  for (i=0;i<std::min(nb_colors,1<<NB_PLANES);i++)
    {
      *(cptr++) = 0x180 + i*2;
      *(cptr++) = rgb[i];
    }
  // bitplanes

  for (i=0;i<NB_PLANES;i++)
    {
      ULONG p = (ULONG)planes[i];

      *(cptr++) = 0x0E0 + i*4;
      *(cptr++) = (p>>16);
      *(cptr++) = 0x0E2 + i*4;
      *(cptr++) = (p & 0xFFFF);
    }

  *(cptr++) = 0x102;
  *(cptr++) = 0;

  *(cptr++) = 0xFFFF;
  *(cptr++) = 0xFFFE;

  return copperlist;
}



void open_screen()
{

  static const UWORD palette[] = {0x0,0x3de,0xf,0xfa0,0xfef,0xff0,0xb60,0xd90,0xf13,0xf0f,0x9ff,0xfff,0x0,0x0,0x0,0x0};

  IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",37);
  if (IntuitionBase == NULL)
    {
      fatal_error("Cannot open intuition.library");
    }

  GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 37);
  if (GfxBase == NULL)
    {
      fatal_error("Cannot open graphics.library");
    }

  detect_controller_types();

  struct NewScreen Screen1 = {
    0,0,320 /*SCREEN_WIDTH*/,240,NB_PLANES,             /* Screen of 640 x 480 depth = NB_PLANES (1<<NB_PLANES colors)   */
    DETAILPEN, BLOCKPEN,
    0,                     /* see graphics/view.h for view modes */
    PUBLICSCREEN|SCREENQUIET,              /* Screen types */
    NULL,                      /* Text attributes (use defaults) */
    (UBYTE *)"My New Screen",
    NULL,
    NULL
  };
  for (int i = 0; i < 2; i++)
    {
      screen[i] = OpenScreen(&Screen1);

      if (!screen[i])
	{
	  fatal_error("Cannot open screen");
	}
      viewport = &screen[i]->ViewPort;
      rastport = &screen[i]->RastPort;
      planes_list[i] = rastport->BitMap->Planes;

      copperlist[i] = make_copperlist(palette,sizeof(palette)/sizeof(*palette),planes_list[i]);

    }

  window = OpenWindowTags(NULL,
			  WA_CustomScreen, (ULONG)screen[1],
			  // WA_Title,       "Press Keys and Mouse in this Window",
			  WA_Width,       320,
			  WA_Height,      240,
			  WA_Activate,    TRUE,
			  WA_CloseGadget, FALSE,
			  WA_RMBTrap,     TRUE,
			  WA_Borderless,     TRUE,
			  WA_IDCMP,IDCMP_VANILLAKEY |
			  IDCMP_RAWKEY,
			  TAG_END);


  apply_copperlist(copperlist[0]);

}

int get_pen(int R,int G,int B)
{
  (void)R,(void)G,(void)B;
  return 0;
}

