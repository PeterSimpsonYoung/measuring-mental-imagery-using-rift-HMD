using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class eyedominancetest : MonoBehaviour {

	public GameObject RedButton;
	public GameObject GreenButton;

	// Use this for initialization
	void Start () {

		Debug.Log("Start called.");

		if (Input.GetKeyDown("Space"))
		{
			Debug.Log("space");
		}

	}

	// Update is called once per frame
	void Update () {


		Debug.Log("Update time: " + Time.deltaTime);
		RedButton.SetActive(true);
		GreenButton.SetActive(true);


	}
}
