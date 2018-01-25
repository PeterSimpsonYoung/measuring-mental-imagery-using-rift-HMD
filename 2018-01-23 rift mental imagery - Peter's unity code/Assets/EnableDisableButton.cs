using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.IO;

public class EnableDisableButton : MonoBehaviour
{

    public GameObject RedButton;
    public GameObject GreenButton;
    public GameObject MockButton; 

    public GameObject PressStart;
    public GameObject Imagine;
    public GameObject Suppress;
    public GameObject Response;
    public GameObject End;

    public GameObject ImagineGreenCucumber;
    public GameObject ImagineGreenBroccoli;
    public GameObject ImagineGreenLime;
    public GameObject ImagineRedApple;
    public GameObject ImagineRedChilli;
    public GameObject ImagineRedTomato;

    public GameObject WhatImagine;
    public GameObject WhatSuppress;
    public GameObject RedOptions;
    public GameObject GreenOptions;

    public GameObject FixationPoint; 

    public float TimeBetweenTrials = 2f;
    public float TimeRivalryShown = .5f;
    public float TimeFixPtShown = .5f; 
    public int NumberOfTrials = 56; //divisible by 8

    private int Started = 0;
    private int TrialCounter = 0;
    private int Finished = 0;

    private int[] cue_array;
    private int[] mock_cue_array;
    private int[] type_array;
    private int[] mock_type_array;
    private int[] condition_array;

    //private int[] red_or_green; //UPDATE THIS BASED ON WHAT MATLAB HAS //for now red= 1 green = 0; 

    private int[] colour_response_array;
    private int[] response_array;
    private int[] answer_array;

    private int BR_counter = 0;
    private int mockBR_counter = 0;

    private int Imagined = 0;
    private int WasGreen = 0;

    public string[] ParticipantName;

    // public GameObject Imagine; 

    //can eventually change to private and use tags to optimize code 

    //public GameObject player;
    //  void Start()
    // {
    //RedButton = GameObject.FindGameObjectWithTag("Red"); 
    //GreenButton = GameObject.FindGameObjectWithTag("Green");
    // }

    void Start()
    {
        float real = (float)0.85;
        float mock = (float)0.15;

        //cue_array and mock_cue_array determine what is to be imagined, there are 6 options. 
        cue_array = new int[Mathf.RoundToInt(NumberOfTrials * real)]; //[Mathf.Round(NumberOfTrials*0.85)];
        mock_cue_array = new int[Mathf.RoundToInt(NumberOfTrials * mock)];

        //Debug.Log(String.Format("There are {0} numbers in the cue_array. There are {1} numbers in the mock_cue_array", cue_array.Length, mock_cue_array.Length));

        //type_array and mock_type_array determine whether the above shoule be suppressed or imagined. 
        type_array = new int[Mathf.RoundToInt(NumberOfTrials * real)];
        mock_type_array = new int[Mathf.RoundToInt(NumberOfTrials * mock)];

        //condition_array determines whether the trial is mock or not. 
        condition_array = new int[NumberOfTrials];

        //red_or_green array knows whether the image suppressed/imagined is red or green 
        //red_or_green = new int[NumberOfTrials]; 

        //These arrays record data/ are used to process data
        colour_response_array = new int[NumberOfTrials];//records whether participant saw red or green or both 
        //should this be separated in mock_colour_response_array and normal? 
        response_array = new int[NumberOfTrials]; //records whether participant pressed 1, 2 or 3 to indicate what it was that they imagined/tried to suppress
        answer_array = new int[NumberOfTrials]; //this is the correct response array it should match with the above. 
        //consider whether these arrays should be separated into mock and normal trials. 

        for (int i = 0; i < Mathf.RoundToInt(NumberOfTrials * real); i++)
        {
            cue_array[i] = i + 1;
            cue_array[i] = cue_array[i] % 6;
            //Debug.Log(String.Format("Value {0} of cue_array is {1} ", i, cue_array[i]));

            type_array[i] = i + 1;
            type_array[i] = type_array[i] % 2;
        }

        //code to shuffle cue_array
        reshuffle(cue_array);
        reshuffle(type_array);

        for (int i = 0; i < Mathf.RoundToInt(NumberOfTrials * mock); i++)
        {
            mock_cue_array[i] = i + 1;
            mock_cue_array[i] = mock_cue_array[i] % 6;
            //Debug.Log(String.Format("Value {0} of mock_cue_array is {1} ", i, mock_cue_array[i]));

            mock_type_array[i] = i + 1;
            mock_type_array[i] = mock_type_array[i] % 2;

            //Debug.Log(String.Format("Value {0} of mock_type_array is {1} ", i, mock_type_array[i]));
        }

        //code to shuffle mock_cue_array 
        reshuffle(mock_cue_array);
        reshuffle(mock_type_array);

        for (int i = 0; i < NumberOfTrials; i++)
        {
            condition_array[i] = i + 1;
            condition_array[i] = condition_array[i] % 7;
        }

        reshuffle(condition_array);

    }

    void reshuffle(int[] texts)
    {
        // Knuth shuffle algorithm (Wikipedia)
        for (int t = 0; t < texts.Length; t++)
        {
            int tmp = texts[t];
            int r = UnityEngine.Random.Range(t, texts.Length);
            texts[t] = texts[r];
            texts[r] = tmp;
        }
    }


    void Update()
    {
        if (Input.anyKey && Started == 0)
        //Input.GetKeyDown(KeyCode.Tab))
        {
            PressStart.GetComponent<MeshRenderer>().enabled = false;
            //RedButton.SetActive(true);            RECENTLY UNCOMMENTED
            //GreenButton.SetActive(true);          RECENTLY UNCOMMENTED
            //Started++;
            //Imagine.SetActive(true); 
            
		//PSY Experimental edits...

			StartCoroutine(ImagineOn());
			//RedButton.SetActive(true);
			//GreenButton.SetActive(true);







        }
    }

    IEnumerator ImagineOn()
    {
        Started++;
        Response.GetComponent<MeshRenderer>().enabled = false;
        RedButton.SetActive(false);
        GreenButton.SetActive(false);
        MockButton.SetActive(false);
        FixationPoint.SetActive(true); 

        if (condition_array[TrialCounter] == 1)
        {

            if (mock_type_array[mockBR_counter] == 1)
            {
                Imagined++;
                Imagine.GetComponent<MeshRenderer>().enabled = true;
                //Debug.Log(String.Format("This mock occurs"));
            }
            else
            {
                Suppress.GetComponent<MeshRenderer>().enabled = true;
            }

            Debug.Log(String.Format("Got to here in mock"));

            if (mock_cue_array[mockBR_counter] == 0)
            {
                WasGreen++;
                answer_array[TrialCounter] = 2;
                ImagineGreenCucumber.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (mock_cue_array[mockBR_counter] == 1)
            {
                WasGreen++;
                answer_array[TrialCounter] = 1;
                ImagineGreenBroccoli.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (mock_cue_array[mockBR_counter] == 2)
            {
                WasGreen++;
                answer_array[TrialCounter] = 3;
                ImagineGreenLime.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (mock_cue_array[mockBR_counter] == 3)
            {
                answer_array[TrialCounter] = 1;
                ImagineRedApple.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (mock_cue_array[mockBR_counter] == 4)
            {
                answer_array[TrialCounter] = 2;
                ImagineRedChilli.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (mock_cue_array[mockBR_counter] == 5)
            {
                answer_array[TrialCounter] = 3;
                ImagineRedTomato.GetComponent<MeshRenderer>().enabled = true;
            }
            mockBR_counter++;

        }
        else
        {

            if (type_array[BR_counter] == 1)
            {
                Imagined++;
                Imagine.GetComponent<MeshRenderer>().enabled = true;
                Debug.Log(String.Format("This true occurs"));
            }
            else
            {
                Suppress.GetComponent<MeshRenderer>().enabled = true;
            }

            Debug.Log(String.Format("Got to here in true"));
            //1. red apple, 2. red chilli, 3. red tomato
            //1. green broccoli, 2. green cucumber, 3. green lime

            if (cue_array[BR_counter] == 0)
            {
                WasGreen++;
                answer_array[TrialCounter] = 2;
                ImagineGreenCucumber.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (cue_array[BR_counter] == 1)
            {
                WasGreen++;
                answer_array[TrialCounter] = 1;
                ImagineGreenBroccoli.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (cue_array[BR_counter] == 2)
            {
                WasGreen++;
                answer_array[TrialCounter] = 3;
                ImagineGreenLime.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (cue_array[BR_counter] == 3)
            {
                answer_array[TrialCounter] = 1;
                ImagineRedApple.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (cue_array[BR_counter] == 4)
            {
                answer_array[TrialCounter] = 2;
                ImagineRedChilli.GetComponent<MeshRenderer>().enabled = true;
            }
            else if (cue_array[BR_counter] == 5)
            {
                answer_array[TrialCounter] = 3;
                ImagineRedTomato.GetComponent<MeshRenderer>().enabled = true;
            }
            BR_counter++;

        }

        //Imagine.GetComponent<MeshRenderer>().enabled = true;

        yield return new WaitForSeconds(TimeBetweenTrials);

        Imagine.GetComponent<MeshRenderer>().enabled = false;
        Suppress.GetComponent<MeshRenderer>().enabled = false;

        ImagineGreenCucumber.GetComponent<MeshRenderer>().enabled = false;
        ImagineGreenBroccoli.GetComponent<MeshRenderer>().enabled = false;
        ImagineGreenLime.GetComponent<MeshRenderer>().enabled = false;
        ImagineRedApple.GetComponent<MeshRenderer>().enabled = false;
        ImagineRedChilli.GetComponent<MeshRenderer>().enabled = false;
        ImagineRedTomato.GetComponent<MeshRenderer>().enabled = false;

        StartCoroutine(FixPtOn1());
        //StartCoroutine(RivalryOn()); 
    }

    IEnumerator RivalryOn()
    {
        if (condition_array[TrialCounter] == 1)
        {
            //FixationPoint.SetActive(true);
            MockButton.SetActive(true);
          
        }
        else
        {
            MockButton.SetActive(false);
            RedButton.SetActive(true);
            GreenButton.SetActive(true);
            //FixationPoint.SetActive(true);
        }
            //Imagine.GetComponent<MeshRenderer>().enabled = false;
        
        yield return new WaitForSeconds(TimeRivalryShown);
        StartCoroutine(FixPtOn2());
    }

    IEnumerator FixPtOn1()
    {

        FixationPoint.SetActive(true);
        PressStart.GetComponent<MeshRenderer>().enabled = false;
        RedButton.SetActive(false);
        GreenButton.SetActive(false);
        MockButton.SetActive(false);
        Response.GetComponent<MeshRenderer>().enabled = false;
        WhatImagine.SetActive(false);
        WhatSuppress.SetActive(false);
        GreenOptions.SetActive(false);
        RedOptions.SetActive(false);
        Imagine.GetComponent<MeshRenderer>().enabled = false;
        Response.GetComponent<MeshRenderer>().enabled = false;
        yield return new WaitForSeconds(TimeFixPtShown);
        StartCoroutine(RivalryOn());
    }

    IEnumerator FixPtOn2()
    {

        FixationPoint.SetActive(true);
        PressStart.GetComponent<MeshRenderer>().enabled = false;
        RedButton.SetActive(false);
        GreenButton.SetActive(false);
        MockButton.SetActive(false);
        Response.GetComponent<MeshRenderer>().enabled = false;
        WhatImagine.SetActive(false);
        WhatSuppress.SetActive(false);
        GreenOptions.SetActive(false);
        RedOptions.SetActive(false);
        Imagine.GetComponent<MeshRenderer>().enabled = false;
        Response.GetComponent<MeshRenderer>().enabled = false;
        yield return new WaitForSeconds(TimeFixPtShown);
        StartCoroutine(InputOn()); 
    }

    IEnumerator FixPtOn3()
    {

        FixationPoint.SetActive(true);
        PressStart.GetComponent<MeshRenderer>().enabled = false;
        RedButton.SetActive(false);
        GreenButton.SetActive(false);
        MockButton.SetActive(false);
        Response.GetComponent<MeshRenderer>().enabled = false;
        WhatImagine.SetActive(false);
        WhatSuppress.SetActive(false);
        GreenOptions.SetActive(false);
        RedOptions.SetActive(false);
        Imagine.GetComponent<MeshRenderer>().enabled = false;
        Response.GetComponent<MeshRenderer>().enabled = false;
        yield return new WaitForSeconds(TimeFixPtShown);
        StartCoroutine(ImagineOn());
    }

    IEnumerator InputOn() //this needs to be made more complex, I think it is a rating scale 
    {
        //yield return new WaitForSeconds(TimeBetweenTrials);
        //yield return StartCoroutine(WaitForKeyDown(KeyCode.Space));

        //Imagine.GetComponent<MeshRenderer>().enabled = false;
        FixationPoint.SetActive(false);
        Response.GetComponent<MeshRenderer>().enabled = true;
        RedButton.SetActive(false);
        GreenButton.SetActive(false);
        MockButton.SetActive(false); 

        //while (!Input.GetKeyDown(KeyCode.LeftArrow) && !Input.GetKeyDown(KeyCode.RightArrow))
        //yield return null;

        while (true) // 1 is left arrow is green, 0 is right arrow is red? 
        {
            if (Input.GetKeyDown(KeyCode.LeftArrow))
            {
                colour_response_array[TrialCounter] = 0;
                break;
            }
            if (Input.GetKeyDown(KeyCode.RightArrow))
            {
                colour_response_array[TrialCounter] = 1;
                break;
            }
            if (Input.GetKeyDown(KeyCode.DownArrow))
            {
                colour_response_array[TrialCounter] = 2;
                break;
            }
            yield return null;
        }
        Response.GetComponent<MeshRenderer>().enabled = false;
        StartCoroutine(CheckInputOn());
        //yield return new WaitForSeconds(TimeBetweenTrials);

    }

    //need a second input where can confirm that participant was imaginging/suppressing right things. !!!

    IEnumerator CheckInputOn()
    {


        if (Imagined != 0)
        {
            WhatImagine.SetActive(true);
        }
        else
        {
            WhatSuppress.SetActive(true);
        }

        if (WasGreen != 0)
        {
            GreenOptions.SetActive(true);
        }
        else
        {
            RedOptions.SetActive(true);
        }

        Imagined = 0;
        WasGreen = 0;

        while (true)

        {
			if (Input.GetKeyDown(KeyCode.Alpha1)) //1. red apple, 2. red chilli, 3. red tomato
                                                   //1. green broccoli, 2. green cucumber, 3. green lime
            {
                response_array[TrialCounter] = 1;
                break;
            }
			if (Input.GetKeyDown(KeyCode.Alpha2))
            {
                response_array[TrialCounter] = 2;
                break;
            }
            if (Input.GetKeyDown(KeyCode.Alpha3))
            {
                response_array[TrialCounter] = 3;
                break;
            }
            yield return null;
        }

        WhatImagine.SetActive(false);
        WhatSuppress.SetActive(false);
        GreenOptions.SetActive(false);
        RedOptions.SetActive(false);

        if (TrialCounter < NumberOfTrials - 1)
        {
            TrialCounter++;
            StartCoroutine(FixPtOn3());
        }
        else
        {
            StartCoroutine(EndOn());
        }
    }

    IEnumerator EndOn()
    {
        Imagine.GetComponent<MeshRenderer>().enabled = false;
        Response.GetComponent<MeshRenderer>().enabled = false;
        End.GetComponent<MeshRenderer>().enabled = true;
        RedButton.SetActive(false);
        GreenButton.SetActive(false);
        MockButton.SetActive(false); 
        yield return new WaitForSeconds(TimeBetweenTrials);
        SaveAll();
        Finished++;
    }

    void SaveAll() //how to save these arrays to a file for analysis 
    {

        //DateTime Tomorrow = DateTime.Now.AddDays(1);
        //string OKD;
        //OKD = Tomorrow.ToString("MMddyyyy");
        //document.SaveAs(FileName: @"C:\Users\Me\Desktop\GenericName" + OKD + ".doc");

       // string[] lines = {textBox2.ToString(), textBox3.ToString() };
       // File.WriteAllLines(string.Format(@"C:\resultats\{0}-{1:dd:MM.yyyy}.txt", textBox1.ID, DateTime.Now), lines);
       
       // string[] lines = { textBox2.ToString(), textBox3.ToString() }; File.WriteAllLines(string.Format(@"resultats\{0}-{1:dd:MM.yy‌​yy}.txt", textBox1.ID.ToString(), DateTime.Now), lines); 

      //  string name = ToString(ParticipantName); 

       // for (int j = 0; j < NumberOfTrials; j++)
       // {
        //    Debug.Log(String.Format("{0} ", ParticipantName); 
  
      //  }
 

        string filePath = @"c:\Users\Peter\Desktop\Zoe_VR\DATA\" + ParticipantName + ".txt";
        string output = "";
        string colour = "";
        string answer = "";

        float performance = 0;
        float mockDetection = 0;
        float mock = (float)0.15;


        if (!File.Exists(filePath))
        {
            // Create a file to write to.
            StreamWriter swNew = File.CreateText(filePath);
            swNew.WriteLine("This is the first time I create this file");
            swNew.Close();
        }
        else
        {
            StreamWriter swAppend = File.AppendText(filePath);
            for (int j = 0; j < NumberOfTrials; j++)
            {
                output += response_array[j].ToString();
                colour += colour_response_array[j].ToString();
                answer += answer_array[j].ToString(); 

                if (response_array[j] == answer_array[j]){
                    performance++; 
                }

                if (colour_response_array[j] == 2 && condition_array[j] == 1)
                {
                    mockDetection++; 
                }
            }

            performance = performance / NumberOfTrials * 100;
            mockDetection = mockDetection / Mathf.RoundToInt(NumberOfTrials * mock) * 100; 

            swAppend.WriteLine("response array:" + output);
            swAppend.WriteLine("answer array:" + answer);
            swAppend.WriteLine("performance percentage: " + performance + "%"); 
            swAppend.WriteLine("colour response array: " + colour);
            swAppend.WriteLine("percentage of mock trials detected: " + mockDetection + "%");
			swAppend.WriteLine (" "); 

            //swAppend.WriteLine("This is the appended line");
            swAppend.Close();


            //StreamWriter swAppend = File.AppendText(filePath);
            //swAppend.WriteLine("This is the appended line");
            //swAppend.Close();
        }

        //Writer(response_array);


        //C:\Users\Pearsonlab\Desktop\Zoe_VR\DATA

        //string name = // whatever you like
        //File.Create("c:\\Users\\Pearsonlab\\Desktop\\Zoe_VR\\DATA\\" + ParticipantName + ".txt");

        //string pathString = @"c:\Users\Pearsonlab\Desktop\Zoe_VR\DATA";

        //string fileName = ParticipantName + ".txt";

        //pathString = System.IO.Path.Combine(pathString, fileName);

        //Console.WriteLine("Path to my file: {0}\n", pathString);

        //if (!System.IO.File.Exists(pathString))
        //{
        //    using (System.IO.FileStream data = System.IO.File.Create(pathString))
        //    {
        //        //for (byte i = 0; i < 100; i++)
        //        //{
        //        //    data.WriteByte(i);
        //        //}
        //        foreach (var item in response_array)
        //        {
        //            data.WriteLine(item);
        //        }
        //    }
        //}
        //else
        //{
        //    Console.WriteLine("File \"{0}\" already exists.", fileName);
        //    return;
        //}

        //string path = System.IO.Path.Combine("c:\\Users\\Pearsonlab\\Desktop\\Zoe_VR\\DATA\\", ParticipantName + ".txt"); // use '+' to combine strings

        //using (StreamWriter data = new StreamWriter(path))
        //{
        //    foreach(var item in response_array)
        //    {
        //        data.WriteLine(item); 
        //    }
        //}

        //File.Create("C:/Users/Pearsonlab/Desktop/Zoe_VR/DATA/" + ParticipantName + ".txt");
        //StreamWriter DATA = new StreamWriter("C:/Users/Pearsonlab/Desktop/Zoe_VR/DATA/" + ParticipantName + ".txt");


        // using (StreamWriter data = new StreamWriter("C:/Users/Pearsonlab/Desktop/Zoe_VR/DATA/" + ParticipantName + ".txt"))
        // {
        //    foreach (var item in response_array)
        //    {
        //       data.WriteLine(item);
        //   }
        //  }

        //data.Close(); 

        // To write array to file

        //for (int j = 0; j < NumberOfTrials; j++)
        //{
        //    DATA.WriteLine(j.ToString() + "RESPONSE ARRAY:    " + Environment.NewLine + response_array);
        //}

        //for (int j = 0; j < NumberOfTrials; j++)
        //{
        //    DATA.WriteLine(j.ToString() + "ANSWER ARRAY:      " + Environment.NewLine + answer_array);
        //}

        //for (int j = 0; j < NumberOfTrials; j++)
        //{
        //    DATA.WriteLine(j.ToString() + "COLOUR RESPONSE ARRAY:     " + Environment.NewLine + colour_response_array);
        //}

        //DATA.Close();




        //using (StreamWriter data = new StreamWriter("../.." + fileLotto + ".txt"))
        //{
        //    for (int i = 0; i < 6; i++)
        //    {
        //        for (int j = 0; j < 7; j++)
        //        {
        //            //Console.Write(random.Next(1, 49));
        //            data.Write(random.Next(1, 49) + " ");

        //        }
        //        Console.WriteLine();
        //    }
        //}
    }

    void Writer(int[] args)
    {
        int x = NumberOfTrials; //dimension
        int[] myArray = new int[x];
        //char FirstNameInitial = ParticipantName[0];
        //char LastNameInitial = ParticipantName[1]; 

        char numbers = 'a';


        //string filePath = @"c:\Users\Pearsonlab\Desktop\Zoe_VR\DATA\" + ParticipantName + ".txt";

        //string filePath = @"c:\Users\Pearsonlab\Desktop\Zoe_VR\DATA\" + ParticipantName + ".txt";

        string filePath = @"c:\Users\Peter\Desktop\Zoe_VR\DATA\" + ParticipantName + ".txt";

        string output = "";

        if (!File.Exists(filePath))
        {
            // Create a file to write to.
            StreamWriter swNew = File.CreateText(filePath);
            swNew.WriteLine("This is the first time I create this file");
            swNew.Close();
        }
        else
        {

            StreamWriter swAppend = File.AppendText(filePath);
            for (int j = 0; j < NumberOfTrials; j++)
            {
                output += response_array[j].ToString();
            }
            swAppend.WriteLine("output");
            //swAppend.WriteLine("This is the appended line");
            swAppend.Close();
        }


        //File.Create("C:/Users/Pearsonlab/Desktop/Zoe_VR/DATA/" + ParticipantName + ".txt");
        //StreamWriter DATA = new StreamWriter("C:/Users/Pearsonlab/Desktop/Zoe_VR/DATA/" + ParticipantName + ".txt");

        //System.IO.StreamWriter streamWriter = new System.IO.StreamWriter(ParticipantName + ".txt");
        //string output = "";

        //for (int j = 0; j < NumberOfTrials; j++)
        //{
        //    output += myArray[j].ToString();
        //}
        //streamWriter.WriteLine(output);
        //output = "";
        //streamWriter.Close();
    }

}



    //create final loop where you can compare the answers of the response array and answer array 
    //save to a file for later access. 
    //confidence loop 
    //after a certain number of trials then you can change the contrast (ie: blocks). 


