export const mergeResults = (results: any[]) => {
  const map: any = {};

  results.forEach((res) => {
    res.parameters?.forEach((p: any) => {
      map[p.parameter] = p;
    });
  });

  return { parameters: Object.values(map) };
};