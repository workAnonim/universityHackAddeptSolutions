using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.VR;

public class VRController : MonoBehaviour {
	bool activeVr;
	public GameObject Cam;
	public GameObject Cam2;
	// Use this for initialization
	void Start () {
		activeVr = true;
	}
	public void ActiveVrController(){
		if (activeVr) {
			Cam2.SetActive (false);
			Cam.SetActive (true);
			disableVr ();
			activeVr = false;
		} else {
			Cam.SetActive (false);
			Cam2.SetActive (true);
			enableVr ();
			activeVr = true;

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
