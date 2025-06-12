import java.awt.event.InputEvent;
import java.awt.AWTException;
import java.awt.Robot;
import processing.net.*;

ArrayList<GameObject> objList = new ArrayList<GameObject>();
ArrayList<int[]> tmp = new ArrayList<int[]>();

boolean onlineMode = false;
String inputIP = "";
boolean ipEntryActive = true;

float camX = 0, camY = -50, camZ = 0;
float camSpeed = 5;
float camYaw = 0, camPitch = 0;
float mouseSensitivity = 0.01f;
Robot robot = null;
float grav = .06;

boolean grounded = true;
double t = 0;
double t1 = 0;
final int STATE_MENU = 0;
final int STATE_PLAYING = 1;
final int STATE_GAMEOVER = 2;
final int STATE_WIN = 3;
final int STATE_NULL = 4;
int fadeTextCount = 0;
int currentLevel = 0;
String[] levelList;
boolean showGameOver = false;
boolean showWinScreen = false;
GameLogic logic;
Renderer r;
int gameState = STATE_MENU;
GameObject curGround;
float vCamX=0;
float vCamZ=0;
float aG = 0;
float[][] positions;
