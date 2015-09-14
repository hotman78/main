class Events{
  private PImage down,up,left,right;
  private float speed;
  private WALK moveOption;
  private int toX,toY;
  private int fromX,fromY;
  private  int DBid;
  private XML MAPs = loadXML("MAPs.xml");
  private Command[] command;
  //子クラスにおいてキャラクター毎に設定していきます。
  private HashMap<String,Integer> flag = new HashMap<String,Integer>();  
  Direction direction;
  int X, Y;
  int PAGE_NUMBER;
  Events(int tX, int tY, int tSpeed, WALK tMoveOption, String image_name, int DBid,int MAP_CHIP_SIZE){
    X=(tX-1)*MAP_CHIP_SIZE;
    Y=(tY-1)*MAP_CHIP_SIZE;
    speed=tSpeed;
    this.direction=Direction.DOWN;
    down =loadImage(image_name+"_down.png");
    up =loadImage(image_name+"_up.png");
    left =loadImage(image_name+"_left.png");
    right =loadImage(image_name+"_right.png"); 
    moveOption=tMoveOption;
    this.fromX=this.X;
    this.fromY=this.Y;
    this.toX=this.X;
    this.toY=this.Y;
    PAGE_NUMBER=MAPs.getChild("草原").getChildren("EVENT")[this.DBid].getChildren("page").length;
    command =new Command[PAGE_NUMBER];
    for(int i=0;i<PAGE_NUMBER;i++){
      command[i] = new Command(this,i);
    }
  }
  
  //キャラクターを描画します。
  void draw(){
    switch(direction){
      case UP:image(up,X,Y);break;
      case DOWN:image(down,X,Y);break;
      case LEFT:image(left,X,Y);break;
      case RIGHT:image(right,X,Y);break;
    }
  }
  
  //キャラクターを動かします。
  void update(){
    for(int i=0;i<MAPs.getChild("草原").getChildren("EVENT")[this.DBid].getChildren("page").length;i++){
      command[i].doCommand();
      command[i].startCommand("parallel");
    }
    
    switch(moveOption){
      case key_walk:key_move();break;
      case random:random_walk();break;
      case stay:break;
      default:break;
    }
    
    if(toX<X)X-=speed;
    if(X<toX)X+=speed;
    if(toY<Y)Y-=speed; //<>//
    if(Y<toY)Y+=speed;
    if(X==toX)fromX=toX;
    if(Y==toY)fromY=toY;
    if(toY-Y<0)direction=Direction.UP;
    if(toY-Y>0)direction=Direction.DOWN;
    if(toX-X<0)direction=Direction.LEFT;
    if(toX-X>0)direction=Direction.RIGHT;
  }  
  
  private void move(Direction muki){
    if((toX-fromX)*muki.dx() < world.MAP_CHIP_SIZE || (toY-fromY)*muki.dy() < world.MAP_CHIP_SIZE)direction=muki;

    if(((toX-fromX)*muki.dx()<world.MAP_CHIP_SIZE || (toY-fromY)*muki.dy()<world.MAP_CHIP_SIZE)
    && !world.maps.here(aboutToX()+muki.dx(),aboutToY()+muki.dy(),"all")){
      toX+=world.MAP_CHIP_SIZE*muki.dx();
      toY+=world.MAP_CHIP_SIZE*muki.dy();
    }
    if(( (toX-fromX)*muki.dx() < world.MAP_CHIP_SIZE || (toY-fromY)*muki.dy() < world.MAP_CHIP_SIZE)&&  !world.maps.here(aboutToX()+muki.dx(),aboutToY()+muki.dy(),"event")){
      for(int i=0;i<MAPs.getChild("草原").getChildren("EVENT")[this.DBid].getChildren("page").length;i++){
        command[i].conntactEvent(world.maps.eventSearch(aboutToX()+1,aboutToY()));
      }
    }
  }
  
  void conntactEvent(){
    for(int i=0;i<MAPs.getChild("草原").getChildren("EVENT")[this.DBid].getChildren("page").length;i++){
      //command[i].conntactEvent(maps.eventSearch(aboutToX()+1,aboutToY()));
    }    
  }
  
  //キャラクターが特定座標にいるか否かを返します
  boolean here(int x,int y){return (x==this.aboutX() && y==this.aboutY());}
  
  private void key_move(){
    if(world.key.up)move(Direction.UP);
    if(world.key.down)move(Direction.DOWN);
    if(world.key.left)move(Direction.LEFT);
    if(world.key.right)move(Direction.RIGHT);
  }
  
  private void random_walk(){
    if(toX-X==0 && toY-Y==0){
      int i =floor(random(0,5));
      switch(i){
        case 1:move(Direction.UP);break;
        case 2:move(Direction.DOWN);break;
        case 3:move(Direction.LEFT);break;
        case 4:move(Direction.RIGHT);break;
      }
    }
  }
/*  boolean col(Direction dir,int y,int x){
    return dir==Direction.STAY && maps.here(x,y,"map");
  }*/
  //キャラクターの位置です。chipX,Yは小数点込み、aboutX,Yは切り捨てて表示されます
  int aboutX(){
    return floor(X/world.MAP_CHIP_SIZE)+1;
  }
  int aboutY(){
    return floor(Y/world.MAP_CHIP_SIZE)+1;
  }
  int aboutToX(){
    return floor(toX/world.MAP_CHIP_SIZE)+1;
  }
  int aboutToY(){
    return floor(toY/world.MAP_CHIP_SIZE)+1;
  }
}