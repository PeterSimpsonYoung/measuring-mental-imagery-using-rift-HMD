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

    private int[] colour_response_array;
    private int[] response_array;
    private int[] answer_array;

    private int BR_counter = 0;
    private int mockBR_counter = 0;

    private int Imagined = 0;
    private int WasGreen = 0;

    public string[] ParticipantName;


    bool step1completed = false;
    bool step2completed = false;

    private float time1;
    private float time2;
    private float stimulusTime;

    // Use this for initialization
    void Start()
    {
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if (Input.anyKey && Started == 0)
        {
            StartCoroutine(TurnOnStimuli());
        }

    }

      IEnumerator TurnOnStimuli()
      {
              
        RedButton.SetActive(true);
        GreenButton.SetActive(true);
        time1 = Time.time;

        Started++;
        print("keypressed - stimuli on");

        yield return new WaitForSeconds(2);;
        StartCoroutine(TurnOffStimuli());

    }

    IEnumerator TurnOffStimuli()
    {
        RedButton.SetActive(false);
        GreenButton.SetActive(false);

        time2 = Time.time;
        stimulusTime = time2 - time1;

        print("stimulus off. Presentation time: " + stimulusTime);
        

        Started = 0; 
        yield break;
    } 

}
