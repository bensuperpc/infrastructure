---
name: OpenCV
description: Image processing and computer vision with OpenCV, in C++ or Python (cv2).
---

OpenCV 4.10 with the contrib modules, for C++ and Python 3.

```cmake
find_package(OpenCV REQUIRED)
target_link_libraries(app PRIVATE ${OpenCV_LIBS})
```

- There is no display: never use `imshow` or `waitKey`. Save results with `cv::imwrite` and check them by values in tests.
- No sample images: create test images in code (`cv::Mat::zeros`, `cv::circle`, `cv::putText`) or ask the user for files.
- `cv::imread` returns an empty `Mat` on failure: check `img.empty()`. Channel order is BGR.
- `cv::Mat` copies share pixels: use `clone()` for an independent copy.
- Python: `import cv2` and `numpy` with the system `python3` (see `python` skill). Images are numpy arrays `(height, width, channels)`.

## Docs

Tutorials in `/docs/opencv/tutorials` (C++) and `/docs/opencv/py_tutorials` (Python). Exact signatures: headers in `/usr/include/opencv4/opencv2/`.
