using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Contrasts : MonoBehaviour
{

    public float green;
    public float red;
    public static Contrasts control;

    Text text;
    public GUISkin skin;


    // Use this for initialization
    void Awake()
    {
        text = GetComponent<Text>();

        if (control == null)
        {
            DontDestroyOnLoad(gameObject);
            control = this;
        }
        else if (control != this)
        {
            Destroy(gameObject);
        }
    }

    void Update()
    {
        print(red);
        text.text = "Red: " + red;

    }
    //void OnGUI()
    //{
    //   GUI.Label(new Rect(10, 10, 100, 30), "Red: " + red);
    //    GUI.Label(new Rect(10, 30, 150, 30), "Green: " + green);
    // }
}
