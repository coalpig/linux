```
PUT /nginx-access-2024.08

POST /nginx-access-2024.08/_mapping
{
  "properties": {
        "geoip": {
          "properties": {
            "location": {
              "type": "geo_point"
            }
          }
        }
      }
}
```