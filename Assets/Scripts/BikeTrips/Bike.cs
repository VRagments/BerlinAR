using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace BerlinAR.XR
{
    public class Bike : MonoBehaviour
    {

        // Route data
        public string Id { get; private set; }

        [SerializeField]
        public List<Vector3> Route { get; private set; }

        public DateTime StartTime { get; private set; }
        public DateTime EndTime { get; private set; }
        public bool Initialized { get; private set; }
       
        // Route distance and prefab
        private float totalDistance;
        private int SPEEDUP_FACTOR = 1;

        // Use this for initialization
        void Start()
        {
        }

        // Update is called once per frame
        void Update()
        {
        }

        public void Init(string id, List<Vector3> route, DateTime startTime, DateTime endTime, int speedup)
        {
            if (id != "" && route.Count > 1)
            {
                //Debug.Log("Initialize new bike route with id " + id + " starting at " + startTime + " seconds " + " for " + duration + " seconds.");
                Id = id;
                Route = new List<Vector3>(route);
                StartTime = startTime;
                EndTime = endTime;
                SPEEDUP_FACTOR = speedup;
                totalDistance = CalculateLength(Route);
                Initialized = true;
            } else
            {
                Initialized = false;
            }
        }

        private float CalculateLength(List<Vector3> route)
        {
            float tmpDistance = 0f;
            if (route.Count <= 1)
            {
                return 0f;
            } else
            {
                for (int i = 1; i < route.Count; i++)
                {
                    tmpDistance += Vector3.Distance(route[i - 1], route[i]);
                }
            }
            return tmpDistance;
        }

        public IEnumerator AnimateAlongPath()
        {
            if (Route == null)
            {
                GameObject.Destroy(this.gameObject);
                yield return null;
            }
            else if (Route.Count <= 1)
            {
                GameObject.Destroy(this.gameObject);
                yield return null;
            }
            else
            {
                this.transform.localPosition = Route[0];
                double duration = (EndTime - StartTime).TotalSeconds / SPEEDUP_FACTOR;
                //Debug.Log("Animate " + Id + " over " + duration + "ticks");
                for (int i = 1; i < Route.Count; i++)
                {
                    yield return MoveAlongSection(Route[i - 1], Route[i], duration);
                }
                GameObject.Destroy(this.gameObject);
            }
        }

        private IEnumerator MoveAlongSection(Vector3 start, Vector3 end, double totalTime)
        {
            double sectionDeltaTime = (Vector3.Distance(start, end) / totalDistance) * totalTime;
            float sectionStartTime = Time.time;
            float coveredTime = 0f;
            while (Time.time < sectionStartTime + sectionDeltaTime)
            {
                coveredTime = (Time.time - sectionStartTime) * (float)sectionDeltaTime;
                this.transform.localPosition = Vector3.Lerp(start, end, coveredTime);
                yield return null;
            }
        }
    }
}