import React, { useEffect, useState } from 'react';

import { getImages, ImageModel } from './data-provider';

function App() {
  const [images, setImages] = useState<ImageModel[]>([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    getImages().then(setImages).catch(setError);
  }, []);

  return (
    <div className="App">
      <h1>App works</h1>
      {error ? (
        <h2>{JSON.stringify(error)}</h2>
      ) : (
        <ImagesList images={images} />
      )}
    </div>
  );
}

function ImagesList({ images }: { images: ImageModel[] }) {
  return (
    <div className="images">
      {images.map((el) => (
        <div key={el.url} className="image-wrapper">
          <AppNetworkImage image={el} />
        </div>
      ))}
    </div>
  );
}

function AppNetworkImage({ image }: { image: ImageModel }) {
  const [imageSrc, setImageSrc] = useState<string>();
  const [blurOverlayVisible, setBlurOverlayVisible] = useState(false);

  useEffect(() => {
    if (image.thumbnail) {
      setImageSrc(`data:image/webp;base64,${image.thumbnail}`);
      setBlurOverlayVisible(true);
    }
    const img = new Image();
    img.onload = () => {
      setImageSrc(image.url);
      setBlurOverlayVisible(false);
    };
    img.src = image.url;
  }, [image]);

  return (
    <div className="image" style={{ height: 500 }}>
      <div
        className="blur-overlay"
        style={{ opacity: blurOverlayVisible ? 1 : 0 }}
      ></div>
      {imageSrc && <img src={imageSrc} alt="Something..." height={500} />}
    </div>
  );
}

export default App;
