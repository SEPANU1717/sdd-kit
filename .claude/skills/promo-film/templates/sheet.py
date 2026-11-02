"""Contact sheet of rendered stills: run inside out/vN.

    python sheet.py sheet.png 0 40 120 ...   (reads still-<f>.png, 4 columns, frame number in red)
"""
import sys
from PIL import Image, ImageDraw
frames=[int(x) for x in sys.argv[2:]]
cols=4; s=480
rows=(len(frames)+cols-1)//cols
o=Image.new('RGB',(cols*s,rows*s),'white'); d=ImageDraw.Draw(o)
for i,f in enumerate(frames):
    im=Image.open(f'still-{f}.png').resize((s,s)); o.paste(im,((i%cols)*s,(i//cols)*s)); d.text(((i%cols)*s+6,(i//cols)*s+4),str(f),fill='red')
o.save(sys.argv[1])
