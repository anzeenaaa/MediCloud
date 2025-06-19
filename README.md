MediCloud is a full-stack healthcare application that leverages artificial intelligence to assist both patients and doctors in disease prediction and personalized healthcare guidance. Built using Flutter for the frontend and Firebase for real-time authentication and cloud storage, MediCloud stands out by integrating two powerful machine learning models into a seamless mobile experience.

The first model is a CNN trained on the CheXpert dataset, designed to predict chest diseases from X-ray images. This model is deployed and accessed via a Python-based FastAPI server. Patients can upload their chest X-rays through the Flutter app and receive immediate diagnostic predictions.

The second model uses natural language processing (NLP) to interpret symptoms typed by the patient. Using the Symptom2Disease dataset, this model predicts the most likely medical condition. Both models are integrated into the app through local APIs, which are called directly from the frontend to fetch real-time prediction results.

In addition to raw predictions, MediCloud incorporates Google’s Gemini LLM to provide personalized healthcare advice, lifestyle changes, and treatment suggestions based on the predicted disease. This transforms the output from just a technical label into meaningful, human-readable guidance that patients can understand and act on.

MediCloud also focuses on explainability in AI. The project includes attempted integration of LIME and SHAP to help doctors understand why a particular disease was predicted. While full implementation of these explainability tools is still in progress, the foundation is in place to support transparent, interpretable AI diagnostics.

From a user experience perspective, the app includes role-based login, directing users to separate dashboards for patients and doctors. All authentication and user data are handled securely via Firebase Authentication and Cloud Firestore. Doctors can access patient histories and are intended to view LIME- or SHAP-based explanations for the latest predictions, helping them validate and trust the system's recommendations.

Overall, MediCloud brings together real-world healthcare problems, powerful machine learning models, ethical AI practices, and modern full-stack app development in one robust solution. The application can be scaled, deployed in real environments, and extended to include features like PDF report generation, multilingual support, or live doctor chat integration.

