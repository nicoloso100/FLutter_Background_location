import { Controller, Get, Query } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(
    @Query('latitude') latitude: number,
    @Query('longitude') longitude: number,
    @Query('date') date: string,
  ): string {
    return this.appService.getHello(latitude, longitude, date);
  }
}
