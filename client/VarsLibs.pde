import java.awt.event.InputEvent;
import java.awt.AWTException;
float camX = 0, camY = -50, camZ = 0;
float camSpeed = 5;
float camYaw = 0, camPitch = 0;
float mouseSensitivity = 0.01f;
Robot robot = null;
float grav = .1;
ArrayList<gameObject> objList = new ArrayList<gameObject>();
ArrayList<int[]> tmp = new ArrayList<int[]>();
boolean grounded = true;
double t = 0;
double t1 = 0;
final int STATE_MENU = 0;
final int STATE_PLAYING = 1;
final int STATE_GAMEOVER = 2;
final int STATE_WIN = 3;
int currentLevel = 0;
String[] levelList;
boolean showGameOver = false;
boolean showWinScreen = false;
gameLogic logic;

int gameState = STATE_MENU;
gameObject curGround;

float aG = 0;
