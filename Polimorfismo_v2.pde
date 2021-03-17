float hp = 0;
float hpMax = 100;
float mp = 0;
float mpMax = 20;
int delay =3000;
int delayMod = 2000;
int counter=120;

Item[] items = new Item[10];
Bar[] bars = new Bar[2];

void setup()
{
    size(500,500);
    
    //Instancia um item para cada índice do array items
    for (int i = 0; i < items.length; i++)
    {
        items[i] = CreateItem();
    }
    
    //Instancia as duas barras de atributos
    bars[0] = new Hp(); 
    bars[1] = new Mp(); 
    
}

void draw()
{
    background(150);
    
    //Fundo da tela baseado na 
    if (mp >= mpMax) fill(75,150,255,0 + mp*12);
    else fill(150,75,255,0 + mp*12);
    rect(0,0,width,height);
    
    
    for (int i = 0; i < items.length; i++)
    {
        if (items[i].MouseOver()) stroke(255);
        else stroke(0);
        
        items[i].DrawBottle();
        
    }
    
    
    bars[0].drawBar();
    bars[1].drawBar();
    
    fill(0,0,0,150);
    textSize(50);
    textAlign(RIGHT,CENTER);
    text(counter, width * 0.95, height * 0.05);
    
    
    if(counter>0) counter--;
   	else
   {
       counter = 160 - (int)(hp);
        
        for (int i = 0; i < items.length; i++)
        {
            items[i] = CreateItem();
        }
    }
    
}

void mousePressed()
{
    for (int i = 0; i < items.length; i++)
    {
        if (items[i].MouseOver()) items[i].Use();
    }
}

class Bar
{
    color barColor;
    float maxValue;
    int barIndex;
    String barType;
    float barSize;
    
    void drawBar()
    {
        stroke(0);
        fill(50);
        rect(width*0.05, height*0.05 + (height *0.05 * barIndex), width *0.5, height *0.02);
        
        textSize(15);
    	textAlign(LEFT,BOTTOM);
        text(barType, width*0.05, height*0.05 + (height *0.05 * barIndex));
        
        if (barType=="HP") barSize = hp / hpMax;
        else if (barType=="MP") barSize = mp / mpMax;
        
        stroke(0,0,0,0);
        fill(barColor);
        rect(width*0.05, height*0.055 + (height *0.05 * barIndex), width * 0.5 * barSize, height *0.010);
    }
}

class Hp extends Bar
{
    Hp()
    {
        barIndex =0;
        barColor = color(100,255,50);
    	barType="HP";
    }
}

class Mp extends Bar
{
    Mp()
    {
        barIndex =1;
        barColor = color(50,100,255);
        barType="MP";
    }
}

Item CreateItem()
{
    Item item;
    int roll = (int)random(1,11);
    
    if (roll <= 3) item = new Life();
    else if (roll <=5) item = new Mana();
    else if (roll <=8) item = new Decay();
    else item = new Wither();
    
    return item;
}

    class Item
    {
        int posX, posY;
        float sizeX, sizeY;
        color itemColor;
        float hpChange;
        float mpChange;
        
        Item()
        {
            sizeX = random(25,50);
            sizeY = random(25,50);
        }
        
        void Use()
        {
        	if (hp + hpChange <0) hp = 0;
          	else if (hp + hpChange > hpMax) hp = hpMax;
          	else hp += hpChange;
          
          	if (mp + mpChange <0) mp = 0;
          	else if (mp + mpChange > mpMax) mp = mpMax;
          	else mp += mpChange;
          
          	posX = 9999;
          	posY = 9999;
      	}
        
      
        void DrawBottle()
        {          
            fill(255,255,255,150);
            rect(posX - sizeX/6, posY - sizeY, sizeX/3, sizeY/2);   
        }
      
    	boolean MouseOver()
        {
            return false;     
        }
    }

    class Potion extends Item
    {
        Potion()
        {
            posX = (int)random(sizeX/2, width-sizeX/2);
            posY = (int)random(height*0.2 + sizeY/2, height-sizeY/2);
        }
        
        void DrawBottle()
      	{          
              super.DrawBottle();
              
              fill(itemColor);   
              ellipse(posX, posY, sizeX, sizeY);
     	 }
        
        boolean MouseOver()
        {
            if (mouseX>posX - sizeX /2 && mouseX<posX+sizeX/2 && mouseY > posY - sizeY /2 && mouseY < posY+sizeY/2) return true;
            else return false;
        }
    }

    class Poison extends Item
    {
        Poison()
        {
            posX = (int)random(sizeX/2, width-sizeX/2);
            posY = (int)random(height*0.2 + 0, height-sizeY);
        }
        
        void DrawBottle()
          {          
              super.DrawBottle();
              
              fill(itemColor);   
              rect(posX - sizeX /2, posY - sizeY /2, sizeX, sizeY);
          }
        
        boolean MouseOver()
        {
            if (dist(mouseX, mouseY, posX, posY) < sizeX/2 && dist(mouseX, mouseY, posX, posY) < sizeY/2) return true;
            else return false;         
        }
    }

    class Life extends Potion
    {
        Life()
        {
            itemColor= color(255,100,100,200);
            hpChange = 10;
        }
        
        void Use()
        {
            println("Usou uma poção de cura!");
            super.Use();
        }
    }

    class Mana extends Potion
    {
        Mana()
        {
            itemColor= color(100,100,255,200);
            mpChange = 2;
        }
        
        void Use()
        {
            println("Usou uma poção de mana!");
            super.Use();
        }
    }

    class Decay extends Poison
    {    
        Decay()
        {
            itemColor= color(50,100,50,200);
            hpChange = -15;
        }
        
        void Use()
        {
            println("Usou um veneno de decaímento!");
            super.Use();
        }
    
    }

    class Wither extends Poison
    {
        Wither()
        {
            itemColor= color(100,50,100,200);
            mpChange = -3;
        }
        
        void Use()
        {
            println("Usou um veneno de murchação!");
            super.Use();
        }
    }
