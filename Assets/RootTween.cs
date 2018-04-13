using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RootTween : MonoBehaviour {
	public float speedRootX = 0.1f;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		gameObject.transform.Rotate (new Vector3 (0f, speedRootX, 0f));
	}
}
