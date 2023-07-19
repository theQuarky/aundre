import fetch from "node-fetch"; // Assuming you have 'node-fetch' installed for making HTTP requests

export const isValidFirebaseAudioUrl = (url: string) => {
    return true;
  try {
    const urlObj = new URL(url);

    // Check if the URL domain is from Firebase Storage
    if (!urlObj.hostname.endsWith("firebasestorage.googleapis.com")) {
      return false;
    }

    // Perform an HTTP HEAD request to check the Content-Type header
    return fetch(url, { method: "HEAD" })
      .then((response) => {
        if (!response.ok) {
          return false;
        }
        const contentType = response.headers.get("content-type");
        return contentType && contentType.startsWith("audio/");
      })
      .catch(() => false);
  } catch (error) {
    return false;
  }
};

export const extractHashtags = (caption: string): string[] => {
  // Extract hashtags using a regular expression
  return caption.match(/#[a-zA-Z0-9_]+/g) || [];
};
