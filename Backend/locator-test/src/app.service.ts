import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(latitude: number, longitude: number, date: string): string {
    console.log(`${latitude}, ${longitude} date: ${date}`);
    return 'ok';
  }
}
