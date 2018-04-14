﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeSkyBox : MonoBehaviour {
	[SerializeField] Material StarSkyBox;
	[SerializeField] AudioSource sound;
	[SerializeField] AudioClip Polet;
	[SerializeField] GameObject Earth;
	[SerializeField] VRController objVRController;
	public float speed=1;
	// Use this for initialization
	void Start () {
		//RenderSettings.skybox.Lerp (a1, a2, speed * Time.deltaTime);
		//RenderSettings.skybox=a2;
	}
	public void ToNight(){
		RenderSettings.skybox=StarSkyBox;
		gameObject.GetComponent<Animator> ().enabled = false;
		//gameObject.SetActive (false);
		sound.clip = Polet;
		sound.Play ();
		Earth.SetActive (true);
		Invoke ("ExitSceneGagarin", 75f);
	}
	void ExitSceneGagarin(){
		objVRController.ActiveVrController ();
	}
	// Update is called once per frame
	void Update () {

	}
}
