using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class T4MTool
{

    public static bool SaveRenderTextureToPNG(RenderTexture rt, string path)
    {
        RenderTexture prev = RenderTexture.active;
        RenderTexture.active = rt;
        Texture2D png = new Texture2D(rt.width, rt.height, TextureFormat.ARGB32, false);
        png.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
        byte[] bytes = png.EncodeToPNG();

        System.IO.File.WriteAllBytes(path, bytes);


        Texture2D.DestroyImmediate(png);
        png = null;
        RenderTexture.active = prev;
        AssetDatabase.ImportAsset(path);
        return true;

    }

    static void ConvT4MObj4Tex(Material t4MMaterial, Transform currentSelect, int TextureSize = 1024)
    {
        string path = EditorUtility.SaveFilePanelInProject("保存图片", "baked", "png", "输入保存图片名");
        if (path.Length > 0)
        {
            RenderTexture rt = new RenderTexture(TextureSize, TextureSize, 0);
         
            Material mat = new Material(Shader.Find("T4M/Tool/Baked 4"));
            mat.CopyPropertiesFromMaterial(t4MMaterial);
            Graphics.Blit(null, rt, mat);
            SaveRenderTextureToPNG(rt, path);
            GameObject.DestroyImmediate(rt);

            mat.shader = Shader.Find("Mobile/Diffuse");
 
            Texture tex = AssetDatabase.LoadAssetAtPath<Texture>(path);
            mat.mainTexture = tex;
            mat.SetTexture("_MainTex", tex);
            Debug.LogError("tex = " + tex);

            AssetDatabase.CreateAsset(mat, path.Substring(0, path.Length - 3) + "mat");

            GameObject g = GameObject.Instantiate(currentSelect.gameObject);
            g.name = currentSelect.name + " Copy";
            Renderer _renderer = g.GetComponent<Renderer>();
            _renderer.sharedMaterial = mat;
            g.transform.position += new Vector3(5, 5, 5);
        }

        //T4MMaterial
    }

    public static void ConvToOneGUI(Transform CurrentSelect)
    {
        GUILayout.BeginVertical();
        GUILayout.Label("Already T4M Object", EditorStyles.boldLabel);
        if (GUILayout.Button("合并到一张图(远景用)"))
        {
            T4MObjSC _T4MObjSC = CurrentSelect.GetComponent<T4MObjSC>();
            if (null != _T4MObjSC.T4MMaterial)
            {
                T4MTool.ConvT4MObj4Tex(_T4MObjSC.T4MMaterial, CurrentSelect);
            }
        }
        if (GUILayout.Button("合并控制图(4层)"))
        {
            T4MObjSC _T4MObjSC = CurrentSelect.GetComponent<T4MObjSC>();
            if (null != _T4MObjSC.T4MMaterial)
            {
                T4MTool.ConvT4MObj4CtrlTex4(_T4MObjSC.T4MMaterial, CurrentSelect);
            }
        }
       
        if (GUILayout.Button("合并控制图(6)层)"))
        {
            T4MObjSC _T4MObjSC = CurrentSelect.GetComponent<T4MObjSC>();
            if (null != _T4MObjSC.T4MMaterial)
            {
                T4MTool.ConvT4MObj4CtrlTex6(_T4MObjSC.T4MMaterial, CurrentSelect);
            }
        }
        GUILayout.EndVertical();
    }

    static void ConvT4MObj4CtrlTex4(Material t4MMaterial, Transform currentSelect, int TextureSize = 1024)
    {
        string path = EditorUtility.SaveFilePanelInProject("保存图片", "bakedCtrl", "png", "输入保存图片名");
        if (path.Length > 0)
        {

            RenderTexture rt = new RenderTexture(TextureSize, TextureSize/4, 0);
            Material mat = new Material(Shader.Find("T4M/Tool/Bake 4 Layer"));
            mat.CopyPropertiesFromMaterial(t4MMaterial);
            float u0 = 1.0f / TextureSize;
            //Debug.LogError("u0="+u0);
            mat.SetFloat("_PixInU", u0);
            Graphics.Blit(null, rt, mat);
            SaveRenderTextureToPNG(rt, path);
            mat.shader = Shader.Find("T4M/Tool/Bake 4 Normal");
            mat.SetFloat("_PixInU", u0);
            path = path.Substring(0, path.Length - 4) + "_Normal.png";
            Graphics.Blit(null, rt, mat);
            SaveRenderTextureToPNG(rt, path);
           

        }
    }
   
    static void ConvT4MObj4CtrlTex6(Material t4MMaterial, Transform currentSelect, int TextureSize = 2048)
    {
        string path = EditorUtility.SaveFilePanelInProject("保存图片", "bakedCtrl5", "png", "输入保存图片名");
        if (path.Length > 0)
        {

            RenderTexture rt = new RenderTexture(TextureSize, TextureSize / 8, 0);
            Material mat = new Material(Shader.Find("T4M/Tool/Bake n Layer"));
            mat.CopyPropertiesFromMaterial(t4MMaterial);
            float u0 = 1.0f / TextureSize;
            Graphics.Blit(null, rt, mat);
            SaveRenderTextureToPNG(rt, path);
            mat.shader = Shader.Find("T4M/Tool/Bake n Normal");
            mat.SetFloat("LayeryCount", 5);
            mat.SetFloat("_PixInU", u0);
            path = path.Substring(0, path.Length - 4) + "_Normal.png";
            Graphics.Blit(null, rt, mat);
            SaveRenderTextureToPNG(rt, path);


        }
    }
}
