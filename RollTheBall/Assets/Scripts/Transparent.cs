using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Transparent : MonoBehaviour
{
    void Start()
    {
        Material m_Material = GetComponent<Renderer>().material;
        m_Material.color = new Color(255, 255, 255, 0);
    }

    void Update()
    {
        
    }
}
