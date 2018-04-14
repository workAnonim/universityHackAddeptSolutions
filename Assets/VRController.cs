using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VR;
using UnityEngine.UI;

public class VRController : MonoBehaviour {
	bool activeVr;
	public GameObject Cam;
	public Animator Light;
	public GameObject Cam2;
	public GameObject Message;
	public Text counte;
	public int count2=0;
	// Use this for initialization
	void Start () {
		activeVr = false;
		count2=15;
		counte.text = count2.ToString ();
	}
	public void ActiveVrController(){
		if (activeVr) {
			
			Cam2.SetActive (false);
			Cam.SetActive (true);
			disableVr ();
			activeVr = false;
			Light.enabled = false;
		} else {
			Message.SetActive (true);
			Invoke ("delayStartVr", 1f);
		}
	}
	void delayStartVr(){
		if (count2 != 0) {
			count2--;
			counte.text = count2.ToString ();
			Invoke ("delayStartVr", 1f);
		}
		else{
			Cam.SetActive (false);
			Cam2.SetActive (true);
			enableVr ();
			activeVr = true;
			Light.enabled = true;
		}
	}
	IEnumerator LoadDevice(string newDevice, bool enable)
	{
		VRSettings.LoadDeviceByName(newDevice);
		yield return null;
		VRSettings.enabled = enable;
	}

	void enableVr()
	{
		StartCoroutine(LoadDevice("Cardboard", true));
	}

	void disableVr()
	{
		StartCoroutine(LoadDevice("", false));
	}
	// Update is called once per frame
	void Update () {
		
	}
}
