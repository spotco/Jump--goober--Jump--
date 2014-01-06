<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>
            Jump*Die*Create
        </title>
		<STYLE type="text/css">
   		body {
		background-color:Black;
		text-align:center;
		color:white;
		}
		.list {
			text-align:left;
		}
		.deemph {
			font-size:12px;
		}
 		</STYLE>

    </head>
    <body>
    	<h1>JUMP*DIE*CREATE</h1> 
    	<h3><?php echo(count(file("levels.txt"))-10); ?> USER SUBMITTED MAPS AND COUNTING ONLINE</h3>
    	<object type="application/x-shockwave-flash"
data="jumpdiecreate.swf"
width="500" height="520" menu=false>
<param name="movie" value="game.swf" menu=false />
</object>
		<p><h3>PLAY WITH ARROW KEYS AND SPACE. If it's blank white, make sure you have flash enabled OR it is loading. If the keys are not working, try clicking on the game.</h3></p>
		<p><strong>UPDATE V0.03:</strong> NEW GRAFIX AND MUSIC LOOK AT THIS SHIT<img src="guystand.png" /></p>
		
		<p class="list"><strong>TO-DO:</strong>
		<ul class="list">
			<li>mute button</li>
			<li>add loadbar</li>
			<li>add tutorial levels 7+</li>
			<li>fix menu+popup window graphics</li>
			<li>add ratings/reviews</li>
			<li>add commentboard</li>
		</ul>
		</p>
		
		<p class="deemph"><em>Quick writeup about level editor</em> since there is no ingame help yet. Bottom left corner is the picker for what kind of block you want to create. Select your type and click and drag on the main screen. Z or click undo to delete.
		To make text, click the T box, click anywhere on screen, enter you text and press ok. The bottom 20 pixels of the screen will not try to make a textbox when you
		click on them, click there to get keyboard focus on the game (same bug mentioned above). Boxes must be at least 7pixels wide+thick or they don't register.
		<strong>To submit a level, beat it.</strong>This will bring up a window option and just follow the instructions. PS. the tutorials were made in the level editor.</p>
		<a href="http://www.spotcos.com/"><p>Back</p></a>
	</body>
</html>