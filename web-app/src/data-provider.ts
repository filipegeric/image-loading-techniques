export interface ImageModel {
  url: string;
  width: number;
  height: number;
  color: string;
  thumbnail: string;
  blurhash: string;
}

export async function getImages() {
  const baseUrl = process.env.API_URL || 'http://localhost:3000';
  const response = await fetch(`${baseUrl}/data`);
  const data: ImageModel[] = await response.json();

  return data;
}
